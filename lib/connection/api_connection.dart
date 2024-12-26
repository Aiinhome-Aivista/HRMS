const baseUrl = "https://aiinhome.com/aiinhome-hrms/API/";

class PostApiConnection {
  String loginapi = '${baseUrl}login.php';
  String locationApi = '${baseUrl}location.php';
  String noticeApi = '${baseUrl}get_notice.php';
}

class GetApiConnection {
  String attandenceGetApi = '${baseUrl}get_attandence.php';
}

class PutApiConnection {}
