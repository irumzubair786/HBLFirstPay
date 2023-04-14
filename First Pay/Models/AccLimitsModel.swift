
import Foundation


struct GetAccLimits2: Codable {
    let responsecode: Int
    let data: DataClassmodel?
    let responseblock: JSONNull?
    let messages: String
}

// MARK: - DataClass
struct DataClassmodel: Codable {
    let accountID: Int?
    let accountNo, levelCode, levelDescr: String?
    let maxAmtLimit, maxAmtPerTxn, dailyLevelDebitLimit, totalDailyLimit: Int?
    let dailyConsumed, dailyDRRemaining, monthlyLevelDebitLimit, totalMonthlyLimit: Int?
    let monthlyConsumed: Double?
    let monthlyDRRemaining, yearlyLevelDebitLimit, totalYearlyLimit: Int?
    let yearlyConsumed: Double?
    let yearlyDRRemaining, dailyLevelCreditLimit, totalDailyLimitCR, dailyReceived: Int?
    let dailyCRRemaining, monthlyLevelCreditLimit, totalMonthlyLimitCR: Int?
    let monthlyReceived: Double?
    let monthlyCRRemaining, yearlyLevelCreditLimit, totalYearlyLimitCR: Int?
    let yearlyReceived: Double?
    let yearlyCRRemaining: Int?

    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case accountNo, levelCode, levelDescr, maxAmtLimit, maxAmtPerTxn, dailyLevelDebitLimit, totalDailyLimit, dailyConsumed
        case dailyDRRemaining = "dailyDrRemaining"
        case monthlyLevelDebitLimit, totalMonthlyLimit, monthlyConsumed
        case monthlyDRRemaining = "monthlyDrRemaining"
        case yearlyLevelDebitLimit, totalYearlyLimit, yearlyConsumed
        case yearlyDRRemaining = "yearlyDrRemaining"
        case dailyLevelCreditLimit
        case totalDailyLimitCR = "totalDailyLimitCr"
        case dailyReceived
        case dailyCRRemaining = "dailyCrRemaining"
        case monthlyLevelCreditLimit
        case totalMonthlyLimitCR = "totalMonthlyLimitCr"
        case monthlyReceived
        case monthlyCRRemaining = "monthlyCrRemaining"
        case yearlyLevelCreditLimit
        case totalYearlyLimitCR = "totalYearlyLimitCr"
        case yearlyReceived
        case yearlyCRRemaining = "yearlyCrRemaining"
    }
}
