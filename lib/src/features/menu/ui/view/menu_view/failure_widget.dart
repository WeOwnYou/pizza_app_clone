part of 'menu_view.dart';

class _BuildFailureWidget extends StatelessWidget {
  const _BuildFailureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Не удалось загрузить'),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: ElevatedButton(
              // TODO(update): update if error
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 11),
                child: Text(
                  'Повторить',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
