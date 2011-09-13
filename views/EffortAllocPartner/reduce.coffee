(keys, values, rereduce) ->
    if rereduce
        return sum values
    total = 0
    for value in values
        total += parseFloat values.value
    return total
