class CommentEntity {
  final int id;
  final String title;
  final String content;
  final String date;
  final String email;

  CommentEntity.formJson (Map<String, dynamic> json ):
  id = json['id'],
  title = json['title'],
  content = json['content'],
  date = json['date'],
  email = json['author']['email'];
}