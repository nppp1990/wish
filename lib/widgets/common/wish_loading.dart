import 'package:flutter/material.dart';
import 'package:wish/utils/example.dart';

enum WishLoadingType {
  loading,
  error,
  empty,
  success,
}

typedef ContentChildBuilder = Widget Function();

class WishLoading extends StatelessWidget {
  final WishLoadingType type;
  final VoidCallback? onRefresh;
  final VoidCallback? onPressEmpty;
  final ContentChildBuilder builder;

  const WishLoading(
      {Key? key, required this.type, required this.builder, this.onRefresh, this.onPressEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    switch (type) {
      case WishLoadingType.loading:
        return _buildLoading();
      case WishLoadingType.error:
        return _buildError();
      case WishLoadingType.empty:
        return _buildEmpty();
      case WishLoadingType.success:
        return builder.call();
    }
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: CircularProgressIndicator(
            // strokeWidth: 5,
            ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('回忆心愿、出了点小差错', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('刷新'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    var emptyTip = ExampleGenerate.generateEmptyTip();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onPressEmpty,
                  child: Text(
                    emptyTip.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                if (emptyTip.author != null)
                  Text('—— ${emptyTip.author}',
                      style: const TextStyle(
                          fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
