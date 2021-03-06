// Test limitations on SPI protocol requirements.

// RUN: %target-typecheck-verify-swift

// Reject SPI protocol requirements without a default implementation.
public protocol PublicProtoRejected {
  @_spi(Private) // expected-error{{protocol requirement 'reqWithoutDefault()' cannot be declared '@_spi' without a default implementation in a protocol extension}}
  func reqWithoutDefault()

  @_spi(Private) // expected-error{{protocol requirement 'property' cannot be declared '@_spi' without a default implementation in a protocol extension}}
  var property: Int { get set }

  @_spi(Private) // expected-error{{protocol requirement 'propertyWithoutSetter' cannot be declared '@_spi' without a default implementation in a protocol extension}}
  var propertyWithoutSetter: Int { get set }

  @_spi(Private) // expected-error{{protocol requirement 'subscript(_:)' cannot be declared '@_spi' without a default implementation in a protocol extension}}
  subscript(index: Int) -> Int { get set }

  @_spi(Private) // expected-error{{protocol requirement 'init()' cannot be declared '@_spi' without a default implementation in a protocol extension}}
  init()

  @_spi(Private) // expected-error{{'@_spi' attribute cannot be applied to this declaration}}
  associatedtype T
}

extension PublicProtoRejected {
  @_spi(Private)
  public var propertyWithoutSetter: Int { get { return 42 } }
}

extension PublicProtoRejected where Self : Equatable {
  @_spi(Private)
  public func reqWithoutDefault() {
    // constrainted implementation
  }
}

// Accept SPI protocol requirements with an implementation.
public protocol PublicProto {
  @_spi(Private)
  func reqWithDefaultImplementation()

  @_spi(Private)
  var property: Int { get set }

  @_spi(Private)
  subscript(index: Int) -> Int { get set }

  @_spi(Private)
  init()
}

extension PublicProto {
  @_spi(Private)
  public func reqWithDefaultImplementation() { }

  @_spi(Private)
  public var property: Int {
    get { return 42 }
    set { }
  }

  @_spi(Private)
  public subscript(index: Int) -> Int {
    get { return 42 }
    set { }
  }

  @_spi(Private)
  public init() { }
}
