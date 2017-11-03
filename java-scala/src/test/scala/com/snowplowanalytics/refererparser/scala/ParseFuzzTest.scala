/**
 * Copyright 2012-2013 Snowplow Analytics Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.snowplowanalytics.refererparser.scala

// Java
import java.net.URI

// Specs2 & ScalaCheck
import org.specs2.{Specification, ScalaCheck}
import org.specs2.matcher.DataTables
import org.scalacheck._
import org.scalacheck.Arbitrary._

class ParseFuzzTest extends Specification with ScalaCheck {

  def is =
    "The parse function should work for any pair of referer and page Strings" ! e1

  def e1 =
    check { (refererUri: String, pageUri: String) => Parser.parse(refererUri, pageUri) must beAnInstanceOf[Parser.MaybeReferer] }
}