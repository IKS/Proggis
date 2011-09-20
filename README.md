Proggis: cross-company project controlling tool
===============================================

Proggis aims to bring clarity into collaborative projects between many companies. It imports project information from multiple sources, merges it, and then provides clear interfaces for analysing the state of the project.

**Note**: Proggis development is just getting started. Watch this space!

The base information managed by Proggis includes:

* Work packages, under projects
* Tasks, under work packages
* Efforts, under tasks
* Deliverables, under tasks
* Budgets, under work packages
* Costs, under work packages

The eventual goal of any project or task is to produce a deliverable. At minimum, a deliverable is identified by a URL. This may be a document, a web page, or a software repository. There will be some special handling for some types of deliverables, including:

* Social networking impact (Tweets, Facebook Likes, and such) of a web page
* Watchers of a software repository
* Participants in an event
* Commits and their sizes of a software repository
* Changes and their changes to a wiki page

It may also be possible to [generate effort numbers](http://timehub.net/) from software commits.

In software projects often the same software repository is the deliverable of multiple tasks. In these situation changes and efforts related to the software may be directed to the correct deliverable based on timing (deliverable for task that was open at the time of commit), or by connection of commits to bug tracker issues that have been assigned to a specific tasks.

### Budget calculations

The system supports person and company-level information to aid cost calculations. If no person-level information is available, then company-level information should be used.

Amount of hours to a task can be calculated from monthly working time and person months to the task, or person months can be calculated from actual reported hours divided by monthly working time, depending which information is available for a given project participant.

A pragmatic way to achieve this is to generate a map providing effort figures from both hour reports and reports of monthly totals, and then reducing it to a sum per participant.

Person costs can similarly be calculated from monthly or hourly costs of the person. On top of that there may be other cost items, like travel expenses. Or the costs of an organization to a task may be reported as a bulk item.

These figures must be time-based, i.e. a new hourly cost of a person only affects hours reported after the date the cost takes effect.

## Target audience

Proggis is targeted at coordinators of large, cross-company projects. It especially aims to assist in generation of quarterly and annual reports needed for EU-funded projects.

It may also be useful for gaining a clear overview into the state of software projects through the ability to merge development progress (commits, bug reports) with the regular project coordination information.

## Views

* Deliverables
  - Current deliverables, with participants and progress
  - Past deliverables, with participants, cost and effort
  - Upcoming deliverables, with cost and schedule estimations
* Deliverable
  - Basic information: description, participants
  - Budget and schedule for the deliverable in case of open ones
  - Efforts done related to the deliverable
  - Activity stream, includong communications related to the deliverable
* Company participating in the project
  - Persons from the company participating in the project, their monthly work hours and cost
  - Current tasks where company is participating, estimated amounts
  - Upcoming tasks where company is participating, schedules
  - Tasks where company has participated, and efforts in them
  - Deliverables the company has participated in
* Person participating in the project
  - Basic profile information: name, email, photo, company
  - Current tasks where person is participating, and estimated amounts
  - Upcoming tasks where person is participating, and schedules
  - Tasks where person has participated, and efforts in them
  - Deliverables person has participated in

## Communication tools

The system provides ways for communicating with project participants. As most of the data sources used do not permit writing, email is the de-facto communications media. Email works in a standard way across corporate boundaries.

Proggis allows the project coordinator to send various notices to project participants by adding comments to deliverables or other information. Some notices may also be set to be automatically generated, including:

* Warnings when a project participant sends efforts for a task that has already ended, or hasn't started yet
* Warnings when efforts to a task exceed the budgeted amount

In order to prevent duplicate notifications, and to keep a track on all activities in the system, all notifications, whether manually sent or automatically generated should be stored into the system, and referenced from related data items.

An important part of communications is the ability to send data requests to project participants. This means writing the request and selecting a data template (spreadsheet) to include in the message. The system should track such requests in order to connect data provided to the original request.

It should also be possible to send planning information, including budgets and work breakdown structure in a machine-readable format to project partners so that they can import it into their own systems.

## How does it work

### Central data storage

Aggregated project information is stored into a CouchDB repository as RDF, encoded via JSON-LD. This makes all project information also available as standard Linked Data for further integration and reuse purposes.

The RDF ontologies used include:

* http://purj.org/stuff/project/

This way, for example a task might be stored as:

    {
        "@subject": "http://company.basecamphq.com/projects/42",
        "@type": "prj:Project",
        "@context": {
            "prj": "http://purj.org/stuff/project/"
        },
        "prj:name": "My cool project"
    }

As reporting capabilities of companies vary, the system allows either down-to-the-detail reporting (with daily hour reports, etc), or quarterly summarization.

### Data merging

All data items (work packages, tasks, efforts, etc) are identified by URIs. Corresponding data items from different sources are recognizable using the RDF seeAlso and sameAs predicates. sameAs indicates a strong one-to-one relationship between the data items, and seeAlso indicates a slightly more loose correspondence.

Handling of these two ways to map URIs from different systems is different:

* An item matching an existing item via sameAs gets its information merged to the matching item, just like an item matching a direct identifier would
* An item matching an existing item via seeAlso gets stored separately. When querying items related to an item, items related to items indicated by the seeAlso predicate also get included into the query

When importing data:

* Check if an item exists with the same identifier. If so, update it
* Check if an item exists with matching sameAs identifier. If so, update it
* Otherwise import the item as a new one

When querying data by reference (e.g. hour reports under a task):

* Find parent based on identifier and sameAs
* Get the identifier, seeAlso and sameAs identifiers of the parent
* Query child items based on all of identifier, seeAlso and sameAs

In situations where new primary items (tasks, persons, etc.) have been received on an import, the project coordinator should be able to merge them with an existing item. When merging, the data items are treated just like they are on initial import (i.e. based on whether the merger is mapped using seeAlso or sameAs predicate).

### Flow-based data processing

All data importing, and generation of reports happens using [NoFlo](https://github.com/bergie/noflo) graphs. This allows easy creation of new flows by reusing existing components in new combinations.

For example, tasks are read from BaseCamp using a process like the following:

* URL and the BaseCamp API key are sent to a BaseCamp reader
* BaseCamp reader fetches tasks from the service, and sends them to a converter
* Converter converts BaseCamp tasks into JSON-LD
* Importer imports each task into the CouchDB repository

Each data importing run, regardless of source, should be trackable separately. This way it is easy to see all information provided in a given data import, and for example to delete it in case of mistakes. See _Workflow execution documents_.

There may be multiple data formats supported by the importing tools. Some useful ones include:

* APIs of common project management web services, like BaseCamp and GitHub
* Spreadsheets, either as Open Document Format (ODF), Excel or CSV
* JSON-LD and XML

Proggis should support at least import, and in some cases export, for these formats. When importing file formats like ODF, Proggis could retain the original imported file as a binary property of the import operation to aid tracing potential import problems due to the file.

#### Workflow execution documents

Each run of a NoFlo workflow should result in a workflow execution document with ´@type` of `execution` to be stored in the database. All documents touched during the workflow run will be tagged with `source` pointing to this document.

Workflows are triggered by creation of a new execution document. There are CouchDB changes API listeners querying these, and based on the state of the execution, and the selected workflow they will initiate the correct NoFlo.

States are:

* waiting_request: the execution needs to send a data request which has not yet been sent
* waiting_response: the execution has sent a data request and is now waiting for response
* data_received: the execution has the data it needs, but it hasn't yet been imported
* data_imported: data has been imported, and is waiting for verification
* accepted: user has accepted the imported data
* rejected: user has rejected the imported data

## Usage

* You need a running CouchDB instance and CoffeeApp
* Install the Proggis views with `coffeeapp push`
* Keep a watcher for data imports running with `$ forever start -o listeners.log listeners.js` in `flows` directory
* If you want to import data manually, run `$ noflo StartEffortFigures.fbp` or `$ noflo StartDeliverables.fbp`
* The user interface is by default in <http://localhost:5984/default/_design/Proggis/index.html>

## Contributing

Proggis is a free software project, available under the [MIT license](http://www.opensource.org/licenses/mit-license.php). Proggis is developed as part of the EU-funded [IKS-project](http://www.iks-project.eu/).

Contributions are very welcome. Just fork this repository and send pull requests.
