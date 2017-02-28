using RemoteFiles
using Base.Test


function capture_stdout(f::Function)
    let fname = tempname()
        try
            open(fname, "w") do fout
                redirect_stdout(fout) do
                    f()
                end
            end
            return readstring(fname)
        finally
            rm(fname, force=true)
        end
    end
end

@testset "RemoteFile" begin
    r = RemoteFile("https://httpbin.org/image/png")
    @test r.file == "png"
    r = RemoteFile("https://httpbin.org/image/png", file="image.png")
    @test r.file == "image.png"

    download(r, verbose=true)
    @test isfile(r.file)
    rm(r.file, force=true)

    @test_throws ErrorException RemoteFile("garbage")

    r = RemoteFile("https://garbage/garbage/garbage.garbage", wait=0, retries=0)
    @test_throws ErrorException download(r)

    r = RemoteFile("https://httpbin.org/image/png", file="image.png", updates=:never)
    download(r, verbose=true)
    c1 = RemoteFiles.createtime(r.file)
    download(r, verbose=true)
    c2 = RemoteFiles.createtime(r.file)
    @test c1 == c2
    rm(r.file, force=true)

    r = RemoteFile("https://httpbin.org/image/png", file="image.png", updates=:always)
    download(r, verbose=true)
    c1 = RemoteFiles.createtime(r.file)
    download(r, verbose=true)
    c2 = RemoteFiles.createtime(r.file)
    @test c1 != c2
    rm(r.file, force=true)
end

@testset "Updates" begin
    updates = :helllottatimes
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test_throws ErrorException RemoteFiles.needsupdate(created, now, updates)

    updates = :mondays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :tuesdays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 7)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :wednesdays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 2, 28)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :thursdays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :fridays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :saturdays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :sundays
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 2)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :yearly
    created = DateTime(2017, 2, 28)
    now = DateTime(2018, 3, 5)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :monthly
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 2, 20)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :weekly
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 6)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == false

    updates = :daily
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 3, 1)
    @test RemoteFiles.needsupdate(created, now, updates) == true
    created = DateTime(2017, 2, 28)
    now = DateTime(2017, 2, 28)
    @test RemoteFiles.needsupdate(created, now, updates) == false
end
