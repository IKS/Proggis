project("save-the-planet",
    time_slots(20, days),
    organisations(["Batman", "Spiderman", "Superman", "Evilman"]),
    tasks([
        [look_for_trouble=task("Look for Trouble"), make_some_trouble=task("Make some trouble")], 
        [find_evil=task("Find evil") , try_to_escape=task("Try to escape")], 
        [catch_bad_guy=task("Catch bad guys") , beat_up_do_gooder=task("Beat up do-gooder")],[have_a_party=task("Have a party")]
    ]),
	allocations([
        allocate("Evilman", make_some_trouble, days(3)),
	    allocate("Batman", look_for_trouble, days(1)),
	    allocate("Spiderman", look_for_trouble, days(1)),
	    allocate("Superman", look_for_trouble, days(1)),
	    allocate("Batman", find_evil, days(3)),
	    allocate("Spiderman", find_evil, days(1)),
	    allocate("Superman", find_evil, days(1)),

	    allocate("Evilman", try_to_escape, days(3))
    ]),
	deliverables([
	    trouble_report=deliverable(look_for_trouble, due(day,5)),
	    bad_guy=deliverable(catch_bad_guy, due(day,7))
	])
)
