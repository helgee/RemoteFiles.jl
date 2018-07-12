import Dates: year, toprev, firstdayofmonth, Date

export isoutdated, lastupdate

daycomp(last, now, dow) = Date(toprev(now, dow, same=true)) >
    Date(toprev(last, dow, same=true))

const upfun = Dict(
    :never => (last, now) -> false,
    :always => (last, now) -> true,
    :daily => (last, now) -> Date(now) > Date(last),
    :monthly => (last, now) ->
        firstdayofmonth(now) > firstdayofmonth(last),
    :yearly => (last, now) -> year(now) > year(last),
    :mondays => (last, now) -> daycomp(last, now, 1),
    :weekly => (last, now) -> daycomp(last, now, 1),
    :tuesdays => (last, now) -> daycomp(last, now, 2),
    :wednesdays => (last, now) -> daycomp(last, now, 3),
    :thursdays => (last, now) -> daycomp(last, now, 4),
    :fridays => (last, now) -> daycomp(last, now, 5),
    :saturdays => (last, now) -> daycomp(last, now, 6),
    :sundays => (last, now) -> daycomp(last, now, 7),
)

lastupdate(rf::RemoteFile) = unix2datetime(stat(path(rf)).mtime)

function isoutdated(last, now, updates)
    if !haskey(upfun, updates)
        error("Unknown update frequency specification: $updates.")
    end

    upfun[updates](last, now)
end

isoutdated(rf::RemoteFile) = isoutdated(lastupdate(rf), now(), rf.updates)
