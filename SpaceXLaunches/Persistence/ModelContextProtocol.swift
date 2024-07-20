import Foundation

/// A protocol that defines the required methods for managing a model context.
///
/// This protocol is intended to be used with different types of model objects,
/// providing a standardized interface for inserting and saving objects in the context.
///
/// - Note: The `ObjectType` associated type represents the type of object that can be managed by this context.
protocol ModelContextProtocol {
  associatedtype ObjectType
  
  /// Inserts an object into the model context.
  ///
  /// - Parameter object: The object to insert into the context.
  /// - Note: This method does not persist the object immediately; you must call `save()` to persist changes.
  func insert(_ object: ObjectType)
  
  /// Saves the changes made to the model context.
  ///
  /// - Throws: An error if saving the changes fails.
  /// - Note: You should call this method after inserting or modifying objects to ensure changes are persisted.
  func save() throws
}
