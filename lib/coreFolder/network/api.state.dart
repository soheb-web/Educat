import 'dart:io';
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/blockBodyModel.dart';
import 'package:educationapp/coreFolder/Model/blockListModel.dart';
import 'package:educationapp/coreFolder/Model/budgetResModel.dart';
import 'package:educationapp/coreFolder/Model/getCreateListModel.dart';
import 'package:educationapp/coreFolder/Model/getMentorReviewModel.dart';
import 'package:educationapp/coreFolder/Model/getNotificationResModel.dart';
import 'package:educationapp/coreFolder/Model/getProfileUserModel.dart';
import 'package:educationapp/coreFolder/Model/getStudentRequestResModel.dart';
import 'package:educationapp/coreFolder/Model/listingBodyModel.dart';
import 'package:educationapp/coreFolder/Model/login.body.model.dart';
import 'package:educationapp/coreFolder/Model/login.rsponse.model.dart';
import 'package:educationapp/coreFolder/Model/mentorNotificationResModel.dart';
import 'package:educationapp/coreFolder/Model/mentorReviewResModel.dart';
import 'package:educationapp/coreFolder/Model/myListingResModel.dart';
import 'package:educationapp/coreFolder/Model/newRegisterResModel.dart';
import 'package:educationapp/coreFolder/Model/passwordChangeBodyModel.dart';
import 'package:educationapp/coreFolder/Model/passwordChangeResModel.dart';
import 'package:educationapp/coreFolder/Model/reportResModel.dart';
import 'package:educationapp/coreFolder/Model/reviewCategoryResModel.dart';
import 'package:educationapp/coreFolder/Model/sendNotifcationBodyModel.dart';
import 'package:educationapp/coreFolder/Model/sendOTPResModel.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/Model/sendRequestResModel.dart';
import 'package:educationapp/coreFolder/Model/skillModel.dart';
import 'package:educationapp/coreFolder/Model/trendingSkillExpertResModel.dart';
import 'package:educationapp/coreFolder/Model/userProfileResModel.dart';
import 'package:educationapp/coreFolder/Model/verifyOrChangePassBodyModel.dart';
import 'package:retrofit/retrofit.dart';
import '../Model/PaymentCreateModel.dart';
import '../Model/PaymentVerifyModel.dart';
import '../Model/VerifyResponseModel.dart';
import '../Model/bodyNewModel.dart';
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
import '../Model/GetCoinModel.dart';
import '../Model/profileGetModel.dart';

part 'api.state.g.dart';

//@RestApi(baseUrl: 'https://educatservicesindia.com/admin/api')
@RestApi(baseUrl: 'https://educatservicesindia.com/admin/api')
abstract class APIStateNetwork {
  factory APIStateNetwork(Dio dio, {String baseUrl}) = _APIStateNetwork;

  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginBodyModel body);

  // @POST("/login")
  // Future<HttpResponse<dynamic>> login(@Body() Map<String, dynamic> body);

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

  // @POST('/register')
  // Future<HttpResponse<dynamic>> register(@Body() RegisterBodyModel body);

  // @MultiPart()
  @MultiPart()
  @POST('/register')
  Future<NewRegisterResModel> registerUser(
    @Part(name: "full_name") String fullName,
    @Part(name: "email") String email,
    @Part(name: "phone_number") String phoneNumber,
    @Part(name: "password") String password,
    @Part(name: "confirm_password") String confirmPass,
    // @Part(name: "dob") String dob,
    @Part(name: "user_type") String userType,
    @Part(name: "service_type") String serviceType,
    //@Part(name: "profile_pic") File? profilePicture,
    @Part(name: "student_id") File? idCards,
  );

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

  @POST("/change-password")
  Future<PasswordChangeResModel> passwordChange(
      @Body() PasswordChangeBodyModel body);

  @POST("/request/send")
  Future<SendRequestResModel> studentSendRequest(
      @Body() SendRequestBodyModel body);

  @GET("/request/GetStudent")
  Future<GetStudentRequestResModel> getRequestStudent();

  @POST("/request/accept")
  Future<AcceptRequestResModel> acceptRequest(
      @Body() AcceptRequestBodyModel body);

  @GET("/mylist")
  Future<MyListingResModel> myListing();

  @POST("/block")
  Future<BlockResModel> block(@Body() BlockbodyModel body);

  @POST("/unblock")
  Future<BlockResModel> unblock(@Body() BlockbodyModel body);

  @GET("/block/list")
  Future<BlockListModel> getBlockList();

  @POST("/report")
  Future<ReportResModel> report(@Body() ReportBodyModel body);

  @GET("/reviews/{id}")
  Future<ReivewCategoryResModel> reviewCategory(@Path('id') String id);

  @POST("/send-password-update-otp")
  Future<HttpResponse> sendOTP(@Body() sendOTPBodyModel body);

  @POST("/updates-password")
  Future<HttpResponse> verifyORChangePass(
      @Body() verifyORChangePasswordBodyModel body);

  @POST("/mentor-review")
  Future<MentorReviewResModel> mentorReview(
    @Body() MentorReviewBodyModel body,
  );

  @GET("/mentor-review/{id}")
  Future<GetmentorReviewModel> getmentorReview(@Path('id') String id);

  @POST("/student-list")
  Future<HttpResponse<dynamic>> createList(@Body() CreatelistBodyModel body);

  @GET("/student-list")
  Future<GetcreatelistModel> getCreateList();

  @POST("/send")
  Future<HttpResponse<dynamic>> sendNotifcation(
      @Body() SendNotifcationBodyModel body);

  @POST("/send-notification")
  Future<HttpResponse<dynamic>> sendNotifcationMentorside(
      @Body() MentorBodyNotification body);

  @GET("/mentor/users")
  Future<GetNotificationResModel> getNotification();

  @POST('/razorpay/order')
  Future<HttpResponse<dynamic>> razorpayOrder(@Body() PaymentCreateModel body);

  @POST('/razorpay/capture')
  Future<VerifyPaymentResponseModel> razorpayOrderVerify(
      @Body() PaymentVerifyModel body);

  @POST("/apply")
  Future<HttpResponse<dynamic>> applyOrSendNotification(
      @Body() ApplybodyModel body);

  @GET("/student/mentor")
  Future<MentorNotificationResModel> mentorSideNotification();

  @GET("/budgets")
  Future<BudgetResModel> fetchBudget();
}
