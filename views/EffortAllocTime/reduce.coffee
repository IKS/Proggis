(keys, values, rereduce) ->
    return sum values if rereduce

    total = 0
    for value in values
        total += parseFloat value.value
    return total
