// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum Discipline: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case singleRope
  case doubleDutch
  case wheel
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SingleRope": self = .singleRope
      case "DoubleDutch": self = .doubleDutch
      case "Wheel": self = .wheel
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .singleRope: return "SingleRope"
      case .doubleDutch: return "DoubleDutch"
      case .wheel: return "Wheel"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Discipline, rhs: Discipline) -> Bool {
    switch (lhs, rhs) {
      case (.singleRope, .singleRope): return true
      case (.doubleDutch, .doubleDutch): return true
      case (.wheel, .wheel): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Discipline] {
    return [
      .singleRope,
      .doubleDutch,
      .wheel,
    ]
  }
}

public enum TrickType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case basic
  case manipulation
  case multiple
  case power
  case release
  case impossible
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "basic": self = .basic
      case "manipulation": self = .manipulation
      case "multiple": self = .multiple
      case "power": self = .power
      case "release": self = .release
      case "impossible": self = .impossible
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .basic: return "basic"
      case .manipulation: return "manipulation"
      case .multiple: return "multiple"
      case .power: return "power"
      case .release: return "release"
      case .impossible: return "impossible"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: TrickType, rhs: TrickType) -> Bool {
    switch (lhs, rhs) {
      case (.basic, .basic): return true
      case (.manipulation, .manipulation): return true
      case (.multiple, .multiple): return true
      case (.power, .power): return true
      case (.release, .release): return true
      case (.impossible, .impossible): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [TrickType] {
    return [
      .basic,
      .manipulation,
      .multiple,
      .power,
      .release,
      .impossible,
    ]
  }
}

public final class TrickDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TrickDetail($trickId: ID!) {
      trick(id: $trickId) {
        __typename
        localisation {
          __typename
          name
          description
        }
        levels {
          __typename
          organisation
          level
        }
        videos {
          __typename
          videoId
        }
      }
    }
    """

  public let operationName: String = "TrickDetail"

  public var trickId: GraphQLID

  public init(trickId: GraphQLID) {
    self.trickId = trickId
  }

  public var variables: GraphQLMap? {
    return ["trickId": trickId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("trick", arguments: ["id": GraphQLVariable("trickId")], type: .object(Trick.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(trick: Trick? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "trick": trick.flatMap { (value: Trick) -> ResultMap in value.resultMap }])
    }

    public var trick: Trick? {
      get {
        return (resultMap["trick"] as? ResultMap).flatMap { Trick(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "trick")
      }
    }

    public struct Trick: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Trick"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("localisation", type: .object(Localisation.selections)),
          GraphQLField("levels", type: .nonNull(.list(.nonNull(.object(Level.selections))))),
          GraphQLField("videos", type: .nonNull(.list(.nonNull(.object(Video.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(localisation: Localisation? = nil, levels: [Level], videos: [Video]) {
        self.init(unsafeResultMap: ["__typename": "Trick", "localisation": localisation.flatMap { (value: Localisation) -> ResultMap in value.resultMap }, "levels": levels.map { (value: Level) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var localisation: Localisation? {
        get {
          return (resultMap["localisation"] as? ResultMap).flatMap { Localisation(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "localisation")
        }
      }

      public var levels: [Level] {
        get {
          return (resultMap["levels"] as! [ResultMap]).map { (value: ResultMap) -> Level in Level(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Level) -> ResultMap in value.resultMap }, forKey: "levels")
        }
      }

      public var videos: [Video] {
        get {
          return (resultMap["videos"] as! [ResultMap]).map { (value: ResultMap) -> Video in Video(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Video) -> ResultMap in value.resultMap }, forKey: "videos")
        }
      }

      public struct Localisation: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TrickLocalisation"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("description", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String, description: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "TrickLocalisation", "name": name, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }
      }

      public struct Level: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TrickLevel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("organisation", type: .nonNull(.scalar(String.self))),
            GraphQLField("level", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(organisation: String, level: String) {
          self.init(unsafeResultMap: ["__typename": "TrickLevel", "organisation": organisation, "level": level])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var organisation: String {
          get {
            return resultMap["organisation"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "organisation")
          }
        }

        public var level: String {
          get {
            return resultMap["level"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "level")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Video"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("videoId", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(videoId: String) {
          self.init(unsafeResultMap: ["__typename": "Video", "videoId": videoId])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var videoId: String {
          get {
            return resultMap["videoId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "videoId")
          }
        }
      }
    }
  }
}

public final class TrickListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TrickList($tricksDiscipline: Discipline) {
      tricks(discipline: $tricksDiscipline) {
        __typename
        id
        trickType
        localisation {
          __typename
          name
        }
        prerequisites {
          __typename
          localisation {
            __typename
            name
          }
        }
        levels {
          __typename
          level
          organisation
        }
      }
    }
    """

  public let operationName: String = "TrickList"

  public var tricksDiscipline: Discipline?

  public init(tricksDiscipline: Discipline? = nil) {
    self.tricksDiscipline = tricksDiscipline
  }

  public var variables: GraphQLMap? {
    return ["tricksDiscipline": tricksDiscipline]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tricks", arguments: ["discipline": GraphQLVariable("tricksDiscipline")], type: .nonNull(.list(.nonNull(.object(Trick.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tricks: [Trick]) {
      self.init(unsafeResultMap: ["__typename": "Query", "tricks": tricks.map { (value: Trick) -> ResultMap in value.resultMap }])
    }

    public var tricks: [Trick] {
      get {
        return (resultMap["tricks"] as! [ResultMap]).map { (value: ResultMap) -> Trick in Trick(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Trick) -> ResultMap in value.resultMap }, forKey: "tricks")
      }
    }

    public struct Trick: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Trick"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("trickType", type: .nonNull(.scalar(TrickType.self))),
          GraphQLField("localisation", type: .object(Localisation.selections)),
          GraphQLField("prerequisites", type: .nonNull(.list(.nonNull(.object(Prerequisite.selections))))),
          GraphQLField("levels", type: .nonNull(.list(.nonNull(.object(Level.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, trickType: TrickType, localisation: Localisation? = nil, prerequisites: [Prerequisite], levels: [Level]) {
        self.init(unsafeResultMap: ["__typename": "Trick", "id": id, "trickType": trickType, "localisation": localisation.flatMap { (value: Localisation) -> ResultMap in value.resultMap }, "prerequisites": prerequisites.map { (value: Prerequisite) -> ResultMap in value.resultMap }, "levels": levels.map { (value: Level) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var trickType: TrickType {
        get {
          return resultMap["trickType"]! as! TrickType
        }
        set {
          resultMap.updateValue(newValue, forKey: "trickType")
        }
      }

      public var localisation: Localisation? {
        get {
          return (resultMap["localisation"] as? ResultMap).flatMap { Localisation(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "localisation")
        }
      }

      public var prerequisites: [Prerequisite] {
        get {
          return (resultMap["prerequisites"] as! [ResultMap]).map { (value: ResultMap) -> Prerequisite in Prerequisite(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Prerequisite) -> ResultMap in value.resultMap }, forKey: "prerequisites")
        }
      }

      public var levels: [Level] {
        get {
          return (resultMap["levels"] as! [ResultMap]).map { (value: ResultMap) -> Level in Level(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Level) -> ResultMap in value.resultMap }, forKey: "levels")
        }
      }

      public struct Localisation: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TrickLocalisation"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "TrickLocalisation", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Prerequisite: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Trick"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("localisation", type: .object(Localisation.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(localisation: Localisation? = nil) {
          self.init(unsafeResultMap: ["__typename": "Trick", "localisation": localisation.flatMap { (value: Localisation) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var localisation: Localisation? {
          get {
            return (resultMap["localisation"] as? ResultMap).flatMap { Localisation(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "localisation")
          }
        }

        public struct Localisation: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["TrickLocalisation"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String) {
            self.init(unsafeResultMap: ["__typename": "TrickLocalisation", "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }

      public struct Level: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TrickLevel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("level", type: .nonNull(.scalar(String.self))),
            GraphQLField("organisation", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(level: String, organisation: String) {
          self.init(unsafeResultMap: ["__typename": "TrickLevel", "level": level, "organisation": organisation])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var level: String {
          get {
            return resultMap["level"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "level")
          }
        }

        public var organisation: String {
          get {
            return resultMap["organisation"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "organisation")
          }
        }
      }
    }
  }
}
