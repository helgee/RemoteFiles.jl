import Base.Dates: year, toprev, firstdayofmonth, firstdayofweek

function needsupdate(created, now, updates)
    if updates == :never
        return false
    elseif updates == :always
        return true
    end
    
    if updates == :daily
        return Date(now) > Date(created)
    elseif updates == :weekly
        return firstdayofweek(now) > firstdayofweek(created)
    elseif updates == :monthly
        return firstdayofmonth(now) > firstdayofmonth(created)
    elseif updates == :yearly
        return year(now) > year(created)
    elseif updates == :mondays
        return toprev(now, 1, same=true) > toprev(created, 1, same=true)
    elseif updates == :tuesdays
        return toprev(now, 2, same=true) > toprev(created, 2, same=true)
    elseif updates == :wednesdays
        return toprev(now, 3, same=true) > toprev(created, 3, same=true)
    elseif updates == :thursdays
        return toprev(now, 4, same=true) > toprev(created, 4, same=true)
    elseif updates == :fridays
        return toprev(now, 5, same=true) > toprev(created, 5, same=true)
    elseif updates == :saturdays
        return toprev(now, 6, same=true) > toprev(created, 6, same=true)
    elseif updates == :sundays
        return toprev(now, 7, same=true) > toprev(created, 7, same=true)
    else
        error("Unknown update frequency specification: $updates.")
    end
end