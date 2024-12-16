

import Foundation
struct GetCardsModal : Codable {
	let flag : Int?
	let message : String?
	let data : [GetCardData]?

}
struct GetCardData : Codable {
    let id : Int?
    let user_id : Int?
    let customer_id : String?
    let card_id : String?
    let tokenization_method : Int?
    let preference : Int?
    let operator_id : Int?
    let last_4 : String?
    let exp_month : Int?
    let exp_year : Int?
    let funding : String?
    let brand : String?
    let is_active : Int?
    let created_at : String?
    let updated_at : String?
}
