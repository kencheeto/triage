public protocol JSONDecodable {
  typealias DecodedType = Self
  class func decode(json: JSON) -> DecodedType?
}
