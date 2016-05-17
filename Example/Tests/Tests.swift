// https://github.com/Quick/Quick

import Quick
import Nimble
import clubhouse_ios_api

class ClubhouseAPISpec: QuickSpec {
    override func spec() {
        describe("singleton") {
            it("should share properties between instantiations") {
                ClubhouseAPI.configure("test1234")
                
                let clubhouse1 = ClubhouseAPI.sharedInstance
                let clubhouse2 = ClubhouseAPI.sharedInstance
                
                expect(clubhouse1.apiToken) == "test1234"
                expect(clubhouse2.apiToken) == "test1234"
            }
        }
    }
}
