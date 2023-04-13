
import Foundation


struct GetAccLimits2: Codable {
    let responsecode: Int
    let data: DataClassmodel?
    let responseblock: JSONNull?
    let messages: String
}

// MARK: - DataClass
struct DataClassmodel: Codable {
    let accountNo: String?
    let maxAmtPerTxn, maxAmtLimit, totalYearlyLimitCR, dailyReceived: Int?
    let dailyLevelCreditLimit, totalMonthlyLimitCR, dailyLevelDebitLimit: Int?
    let yearlyReceived: Double?
    let monthlyLevelDebitLimit, accountID, totalDailyLimitCR, totalMonthlyLimit: Int?
    let monthlyReceived: Double?
    let dailyConsumed, totalYearlyLimit, monthlyConsumed, monthlyLevelCreditLimit: Int?
    let totalDailyLimit, yearlyLevelCreditLimit: Int?
    let levelDescr: String?
    let yearlyConsumed, yearlyLevelDebitLimit: Int?

    enum CodingKeys: String, CodingKey {
        case accountNo, maxAmtPerTxn, maxAmtLimit
        case totalYearlyLimitCR = "totalYearlyLimitCr"
        case dailyReceived, dailyLevelCreditLimit
        case totalMonthlyLimitCR = "totalMonthlyLimitCr"
        case dailyLevelDebitLimit, yearlyReceived, monthlyLevelDebitLimit
        case accountID = "accountId"
        case totalDailyLimitCR = "totalDailyLimitCr"
        case totalMonthlyLimit, monthlyReceived, dailyConsumed, totalYearlyLimit, monthlyConsumed, monthlyLevelCreditLimit, totalDailyLimit, yearlyLevelCreditLimit, levelDescr, yearlyConsumed, yearlyLevelDebitLimit
    }
}
