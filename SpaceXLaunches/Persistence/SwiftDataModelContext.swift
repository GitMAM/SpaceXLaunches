import SwiftData

/// A generic implementation of `ModelContextProtocol` that works with persistent model objects.
///
/// This class adapts the `ModelContext` type from SwiftData to work with any model type conforming to `PersistentModel`.
///
/// - Note: The `ObjectType` is specified by the generic type `T`, which must be a `PersistentModel`.
/// - Note: This class provides a way to interact with a SwiftData context while ensuring type safety for model objects.
class SwiftDataModelContext<T: PersistentModel>: ModelContextProtocol {
  typealias ObjectType = T
  
  private let modelContext: ModelContext
  
  /// Initializes a new `SwiftDataModelContext` with a given `ModelContext`.
  ///
  /// - Parameter modelContext: The `ModelContext` instance to use for managing the persistence of model objects.
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  /// Inserts a model object into the context.
  ///
  /// - Parameter object: The model object to be inserted into the context.
  /// - Note: This method schedules the object for insertion but does not immediately persist changes.
  func insert(_ object: T) {
    modelContext.insert(object)
  }
  
  /// Saves the changes made to the context.
  ///
  /// - Throws: An error if saving the changes fails.
  /// - Note: Call this method after making changes to ensure they are persisted.
  func save() throws {
    try modelContext.save()
  }
}
