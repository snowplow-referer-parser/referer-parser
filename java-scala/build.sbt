name          := "referer-parser"
organization  := "com.snowplowanalytics"
version       := "0.3.0"
description   := "Library for extracting marketing attribution data from referer URLs"
scalaVersion  := "2.12.4"
crossScalaVersions := Seq("2.11.11", "2.12.4")
scalacOptions := Seq("-deprecation", "-encoding", "utf8")
resolvers     += "SnowPlow Analytics Maven repo" at "http://maven.snplow.com/releases/"

libraryDependencies ++= Seq(
  "org.yaml" % "snakeyaml" % "1.19",
  "org.apache.httpcomponents" % "httpclient" % "4.5.3",
  "org.specs2" %% "specs2" % "2.5" % "test",
  "junit" % "junit" % "4.12" % "test",
  "org.json" % "json" % "20170516" % "test",
  "org.json4s" %% "json4s-jackson" % "3.5.3" % "test",
  "org.json4s" %% "json4s-scalaz"  % "3.5.3" % "test"
)


