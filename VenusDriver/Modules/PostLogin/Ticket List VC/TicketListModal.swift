

import Foundation
struct TicketListModal : Codable {
	let flag : Int?
	let message : String?
	let data : [TicketListData]?

}
struct TicketListData : Codable {
    let id : Int?
    let user_id : Int?
    let user_type : Int?
    let ride_id : Int?
    let subject : String?
    let description : String?
    let status : Int?
    let admin_id : String?
    let response_at : String?
    let admin_response : String?
    let created_at : String?
    let updated_at : String?
    let image : String?
    let operator_id : Int?
    let city_id : Int?
}
