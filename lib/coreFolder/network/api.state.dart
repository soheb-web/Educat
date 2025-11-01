import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/getProfileUserModel.dart';
import 'package:educationapp/coreFolder/Model/login.body.model.dart';
import 'package:educationapp/coreFolder/Model/skillModel.dart';
import 'package:educationapp/coreFolder/Model/trendingSkillExpertResModel.dart';
import 'package:educationapp/coreFolder/Model/userProfileResModel.dart';
import 'package:retrofit/retrofit.dart';
import '../Model/service.model.dart';
import '../Model/mentorHomeModel.dart';
import '../Model/CollegeSearchModel.dart';
import '../Model/GetDropDownModel.dart';
import '../Model/GetSkillModel.dart';
import '../Model/HomeStudentDataModel.dart';
import '../Model/ReviewGetModel.dart';
import '../Model/SearchCompanyModel.dart';
import '../Model/TransactionGetModel.dart';
import '../Model/searchMentorModel.dart';
import '../Model/ResisterModel.dart';
import '../Model/GetCoinModel.dart';
import '../Model/profileGetModel.dart';

part 'api.state.g.dart';

@RestApi(baseUrl: 'https://education.globallywebsolutions.com/api')
abstract class APIStateNetwork {
  factory APIStateNetwork(Dio dio, {String baseUrl}) = _APIStateNetwork;

  // @POST('/login')
  // Future<HttpResponse<dynamic>> login(@Body() LoginBodyModel body);

  @POST("/login")
  Future<HttpResponse<dynamic>> login(@Body() Map<String, dynamic> body);

  @POST('/mentor/buy-coins')
  Future<HttpResponse<dynamic>> buyCoin(@Body() Map<String, dynamic> body);

  @GET('/reviews-Get/{id}')
  Future<ReviewGetModel> getReview(@Path('id') String id);

  @GET('/mentor/Transaction/{id}')
  Future<TransactionGetModel> getTransaction(@Path('id') String id);

  @GET('/profile/{id}')
  Future<ProfileGetModel> mentorProfile(@Path('id') String id);

  @GET("/profiles")
  Future<UserProfileResModel> userProfile();

  @GET('/collages')
  Future<SearchCollegeModel> getAllSearchCollege(
    @Query("location") String location,
    @Query("course") String course,
    @Query("college_name") String collegeName,
  );

  @GET('/companies')
  Future<SearchCompanyModel> getAllSearchCompany(
    @Query("skills") String skills,
    @Query("industry") String industry,
    @Query("location") String location,
  );

  @GET('/mentor-search')
  Future<SearchMentorModel> getAllSearchMentor(
    @Query("skills_id") String skillsId,
    @Query("users_field") String usersField,
    @Query("total_experience") String totalExperience,
  );

  @GET('/getskills-search')
  Future<SkillGetModel> getSkill(
    @Query("level") String level,
    @Query("industry") String industry,
  );

  @POST('/register')
  Future<HttpResponse<dynamic>> register(@Body() RegisterBodyModel body);

  @GET('/dropdowns')
  Future<GetDropDownModel> getDropDownApi();

  @GET('/services')
  Future<ServiceModelRes> service();

  @GET('/homepage')
  Future<HomeStudentDataModel> getStudentHomeApi();

  @GET('/Mentor/homepage')
  Future<MentorHomeModel> getMentorHomeApi();

  @GET('/Get-Coin-Plan')
  Future<GetCoinModel> getCoinApi();

  @POST('/reviews/store')
  Future<HttpResponse<dynamic>> saveReview(
    @Body() Map<String, dynamic> body,
  );

  @GET('/get-all-skills')
  Future<SkillsModel> getAllSkill();

  @GET('/profiles')
  Future<GetUserProfileModel> profiles();

  @GET("/skills/experts/{id}")
  Future<TrendingExpertResModel> exprtTrendingSkill(@Path("id") String id);
}
