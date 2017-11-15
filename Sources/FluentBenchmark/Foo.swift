import Async
import Fluent
import Foundation

internal final class Foo<D: Database>: Model {
    /// See Model.Database
    typealias Database = D

    /// See Model.ID
    typealias ID = UUID

    /// See Model.name
    static var name: String { return "foo" }

    /// See Model.idKey
    static var idKey: IDKey { return \.id }

    /// See Model.keyFieldMap
    static var keyFieldMap: KeyFieldMap {
        return [
            key(\.id): field("id"),
            key(\.bar): field("bar"),
            key(\.baz): field("baz")
        ]
    }

    /// Foo's identifier
    var id: UUID?

    /// Test string
    var bar: String

    /// Test integer
    var baz: Int

    /// Create a new foo
    init(id: ID? = nil, bar: String, baz: Int) {
        self.id = id
        self.bar = bar
        self.baz = baz
    }
}

internal struct FooMigration<D: Database>: Migration where D.Connection: SchemaSupporting {
    /// See Migration.database
    typealias Database = D

    /// See Migration.prepare
    static func prepare(on connection: Database.Connection) -> Future<Void> {
        return connection.create(Foo<Database>.self) { builder in
            try builder.field(
                type: Database.Connection.FieldType.makeSchemaFieldType(for: .uuid),
                for: \Foo<Database>.id
            )
            try builder.field(
                type: Database.Connection.FieldType.makeSchemaFieldType(for: .string),
                for: \Foo<Database>.bar
            )
            try builder.field(
                type: Database.Connection.FieldType.makeSchemaFieldType(for: .int),
                for: \Foo<Database>.baz
            )
        }
    }

    /// See Migration.revert
    static func revert(on connection: Database.Connection) -> Future<Void> {
        return connection.delete(Foo<Database>.self)
    }
}
