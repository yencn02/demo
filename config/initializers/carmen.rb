states = Carmen::states('US')
states.delete_at(60)
states.delete_at(59)
states.delete_at(58)
Carmen::states('US').concat(Carmen::states('CA'))
Carmen::COUNTRIES.delete_if{|x| !["US", "CA"].index(x[1])}