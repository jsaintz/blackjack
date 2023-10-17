class ActionButton {
  final String label;
  final bool enabled;
  final Function() onPressed;

  ActionButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });
}
