(:~
 : Test cases for the Shakespeare search app.
 :)
xquery version "1.0";

module namespace t="http://exist-db.org/apps/demo/shakespeare/tests";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace shakes="http://exist-db.org/apps/demo/shakespeare" at 
    "../web/shakespeare.xql";

(:~
 : Test translation of query parameters into a full text query.
 :)
declare 
    %test:args("love", "all")
    %test:assertEquals("<query><term occur='must'>love</term></query>")
    %test:args("cursed spite", "all")
    %test:assertEquals("<query><term occur='must'>cursed</term><term occur='must'>spite</term></query>")
    %test:args("cursed spite", "any")
    %test:assertEquals("<query><term occur='should'>cursed</term><term occur='should'>spite</term></query>")
function t:create-query($queryStr as xs:string?, $mode as xs:string) {
    shakes:create-query($queryStr, $mode)
};

(:~
 : Test the actual query function: should return a scene with the
 : search terms highlighted.
 :)
declare 
    %test:args('"fenny snake"', "all")
    %test:assertXPath("contains($result//exist:match/.., 'fenny snake')", "true")
function t:query($queryStr as xs:string?, $mode as xs:string) {
    shakes:do-query($queryStr, $mode)
};

(:~
 : Test result display.
 :)
declare
    %test:args('"fenny snake"', "all")
    %test:assertXPath("count($result[@class='scene']) = 2")
    %test:assertXPath("$result/table/tr/td[@class='hi'] = 'fenny'")
function t:show-hits($queryStr as xs:string?, $mode as xs:string) {
    let $result := shakes:do-query($queryStr, $mode)
    return
        shakes:show-hits((), (), $result)
};