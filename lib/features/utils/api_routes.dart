
class ApiRoutes{
static const String baseUrl = 'https://bookappbackend-csjm.onrender.com/api';
static const String registerEndpoint = '$baseUrl/register';
static const String loginEndpoint = '$baseUrl/login';
static const String newReleaseEndpoint = '$baseUrl/new-release-section';
static const String searchEndpoint = '$baseUrl/search';
static const String allBookEndpoint = '$baseUrl/category';
static String categoryEndpoint(String category) => '$baseUrl/books?category=$category';
static const String suggestedEndpoint = '$baseUrl/suggested';
static const String studyBookEndpoint = '$baseUrl/suggested?category=study books';
static String bookByIdEndpoint(String id) => '$baseUrl/bookId/$id';
}