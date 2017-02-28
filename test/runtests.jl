using RemoteFiles
using Base.Test

@testset "RemoteFile" begin
    r = RemoteFile("https://httpbin.org/image/png")
    @test r.file == "png"
    r = RemoteFile("https://httpbin.org/image/png", file="image.png")
    @test r.file == "image.png"
end
