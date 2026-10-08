/// Lets the wizard ask the visible step to save before moving on.
/// A step sets [save] in initState; it returns false to stay on the step
/// (for example when a field has an error).
class StepController {
  Future<bool> Function()? save;
}
