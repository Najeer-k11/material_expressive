import 'package:flutter/material.dart';

class ChatTemplate extends StatelessWidget {
  const ChatTemplate({
    super.key,
    required this.messages,
    required this.inputField,
    this.sendButton,
    this.title,
    this.avatar,
    this.actions = const [],
    this.onSend,
  });

  final List<Widget> messages;
  final Widget inputField;
  final Widget? sendButton;
  final String? title;
  final Widget? avatar;
  final List<Widget> actions;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: title != null
            ? Row(
                children: [
                  if (avatar != null) ...[avatar!, const SizedBox(width: 12)],
                  Text(title!),
                ],
              )
            : null,
        actions: actions,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (_, i) => messages[messages.length - 1 - i],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(child: inputField),
                  const SizedBox(width: 8),
                  sendButton ??
                      IconButton.filled(
                        onPressed: onSend,
                        icon: const Icon(Icons.send),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isOutgoing = false,
    this.timestamp,
    this.avatar,
  });
  final String message;
  final bool isOutgoing;
  final String? timestamp;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isOutgoing
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutgoing && avatar != null) ...[
            avatar!,
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isOutgoing
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isOutgoing ? 18 : 4),
                  bottomRight: Radius.circular(isOutgoing ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isOutgoing
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface,
                    ),
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      timestamp!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            (isOutgoing
                                    ? scheme.onPrimaryContainer
                                    : scheme.onSurfaceVariant)
                                .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
