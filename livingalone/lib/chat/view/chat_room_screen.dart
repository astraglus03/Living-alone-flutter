import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:livingalone/chat/models/chat_message_model.dart';
import 'package:livingalone/chat/view/chat_list_screen.dart';
import 'package:livingalone/chat/view_models/chat_provider.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/component/options_menu.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/report/report_screen.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String opponentName;
  final String opponentProfileUrl;
  final ChatRoom chatRoom;

  const ChatRoomScreen({
    required this.roomId,
    required this.opponentName,
    required this.opponentProfileUrl,
    required this.chatRoom,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _focusNode = FocusNode();
  
  // 상수 정의
  static const double _actionPanelHeight = 270.0;
  static const Duration _animationDuration = Duration(milliseconds: 100);
  
  bool _showKeyboard = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messageController.addListener(() => setState(() {}));
    _focusNode.addListener(_onFocusChange);

    // 읽음 처리
    ref.read(chatMessagesProvider.notifier).markAsRead(widget.roomId);

    // 첫 로드 후 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_showKeyboard) {
      setState(() => _showKeyboard = true);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 키보드 상태 변경시 자동 스크롤
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      Future.delayed(Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _toggleInputMode() {
    setState(() {
      _showKeyboard = !_showKeyboard;
      if (_showKeyboard) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      // TODO: 이미지 전송 구현
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatMessageProvider(widget.roomId).notifier).sendMessage(text);
    _messageController.clear();

    // 약간의 지연 후 스크롤 (메시지가 추가된 후)
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(chatMessageProvider(widget.roomId));
    
    return DefaultLayout(
      title: widget.opponentName,
      actions: IconButton(
        onPressed: () => _showOptionsMenu(context),
        icon: const Icon(Icons.more_horiz_rounded),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (!_showKeyboard) setState(() => _showKeyboard = true);
        },
        child: Column(
          children: [
            _buildRoomInfoHeader(),
            _buildMessageList(messageState),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }
  
  // 채팅방 상단 정보 헤더
  Widget _buildRoomInfoHeader() {
    return Container(
      height: 72.h,
      padding: EdgeInsets.all(12).w,
      decoration: const BoxDecoration(color: GRAY100_COLOR),
      child: Row(
        children: [
          // 썸네일 이미지
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: GRAY200_COLOR,
              image: widget.chatRoom.thumbnailUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.chatRoom.thumbnailUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          12.horizontalSpace,
          // 방 정보 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 타이틀
                Text(
                  widget.chatRoom.title,
                  style: AppTextStyles.body2.copyWith(color: GRAY800_COLOR),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                // 상세 정보 행
                _buildRoomDetailRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 채팅방 상세 정보 행
  Widget _buildRoomDetailRow() {
    return Row(
      children: [
        // 단기 렌트 라벨
        if(widget.chatRoom.rentType == RentType.shortRent.label)
          Container(
            padding: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: BLUE100_COLOR,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '단기',
              style: AppTextStyles.caption2.copyWith(
                  color: BLUE400_COLOR,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
        // 위치
        Text(
          widget.chatRoom.location,
          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
        ),
        // 방 타입 추가 정보
        if (widget.chatRoom.type == 'ROOM') 
          _buildRoomTypeInfo()
        else if (widget.chatRoom.type == 'TICKET')
          _buildTicketTypeInfo(),
      ],
    );
  }
  
  // 방 타입 상세 정보
  Widget _buildRoomTypeInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDivider(),
        Text(
          widget.chatRoom.buildingType ?? '',
          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
        ),
        _buildDivider(),
        Text(
          widget.chatRoom.monthlyRent != null
              ? '월세 ${widget.chatRoom.monthlyRent}'
              : widget.chatRoom.deposit != null
                  ? '전세 ${widget.chatRoom.deposit}'
                  : '',
          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
        ),
      ],
    );
  }
  
  // 티켓 타입 상세 정보
  Widget _buildTicketTypeInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDivider(),
        Text(
          widget.chatRoom.ticketType ?? '',
          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
        ),
      ],
    );
  }
  
  // 구분선
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 1.w,
      height: 10.h,
      color: GRAY400_COLOR,
    );
  }
  
  // 메시지 목록
  Widget _buildMessageList(ChatMessageState messageState) {
    if (messageState.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    
    if (messageState.error != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                messageState.error!,
                style: AppTextStyles.body1.copyWith(color: ERROR_TEXT_COLOR),
              ),
              TextButton(
                onPressed: () => ref.read(chatMessageProvider(widget.roomId).notifier).loadMessages(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (messageState.messages.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            '메시지가 없습니다.',
            style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
          ),
        ),
      );
    }
    
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        reverse: false,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: messageState.messages.length,
        itemBuilder: (context, index) {
          final messages = messageState.messages;
          final message = messages[index];
          
          // 날짜 구분선 표시 여부
          final showDate = index == 0 ||
              !_isSameDay(message.createdAt, messages[index - 1].createdAt);
              
          // 시간 표시 여부  
          final isLastMessage = index == messages.length - 1;
          final showTime = isLastMessage ||
              (index < messages.length - 1 && (
                !_isSameTime(message.createdAt, messages[index + 1].createdAt) ||
                message.senderId != messages[index + 1].senderId
              ));

          return Column(
            children: [
              if (showDate) _DateDivider(date: message.createdAt),
              _MessageBubble(
                message: message,
                showTime: showTime,
                opponentProfileUrl: widget.opponentProfileUrl,
              ),
            ],
          );
        },
      ),
    );
  }
  
  // 입력 섹션 (메시지 입력창 + 액션 패널)
  Widget _buildInputSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 메시지 입력창
        AnimatedPadding(
          duration: _animationDuration,
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: GRAY100_COLOR,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                // 토글 버튼 (플러스/닫기)
                _buildToggleButton(),
                // 텍스트 필드
                _buildMessageTextField(),
                // 전송 버튼
                _buildSendButton(),
              ],
            ),
          ),
        ),
        
        // 액션 패널 and 키보드 패딩
        10.verticalSpace,
        if (!_showKeyboard) _buildActionPanel(),
        SizedBox(
          height: _showKeyboard
              ? max(0, MediaQuery.of(context).viewInsets.bottom - 10.h)
              : 0
        ),
      ],
    );
  }
  
  // 토글 버튼 (플러스/닫기)
  Widget _buildToggleButton() {
    return IconButton(
      style: IconButton.styleFrom(overlayColor: Colors.transparent),
      onPressed: _toggleInputMode,
      icon: Icon(
        _showKeyboard ? Icons.add : Icons.close,
        color: GRAY600_COLOR,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 40.w,
        minHeight: 40.h,
      ),
    );
  }
  
  // 메시지 입력 텍스트 필드
  Widget _buildMessageTextField() {
    return Expanded(
      child: TextField(
        controller: _messageController,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        focusNode: _focusNode,
        onTap: () {
          if (!_showKeyboard) {
            setState(() => _showKeyboard = true);
          }
        },
        style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
        decoration: InputDecoration(
          hintText: '메시지를 입력하세요',
          hintStyle: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }
  
  // 전송 버튼
  Widget _buildSendButton() {
    final bool isEnabled = _messageController.text.trim().isNotEmpty;
    
    return IconButton(
      style: IconButton.styleFrom(overlayColor: Colors.transparent),
      onPressed: isEnabled ? _sendMessage : null,
      icon: Icon(
        Icons.send_rounded,
        color: isEnabled ? BLUE400_COLOR : GRAY400_COLOR,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 40.w,
        minHeight: 40.h,
      ),
    );
  }
  
  // 액션 패널 (카메라, 앨범, 위치 등)
  Widget _buildActionPanel() {
    return Container(
      height: _actionPanelHeight.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 0.75,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildActionButton(
            icon: Icons.camera_alt,
            label: '카메라',
            color: BLUE400_COLOR,
            onTap: () {}, // TODO: 카메라 기능 구현
          ),
          _buildActionButton(
            icon: Icons.image,
            label: '앨범',
            color: Color(0xFFF7CE45),
            onTap: _pickImage,
          ),
          _buildActionButton(
            icon: Icons.location_on,
            label: '장소',
            color: Color(0xFF4DA6A6),
            onTap: () {}, // TODO: 위치 기능 구현
          ),
          // 추가 버튼들을 여기에 넣을 수 있습니다
        ],
      ),
    );
  }

  // 액션 버튼 위젯
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: WHITE100_COLOR),
          ),
          8.verticalSpace,
          Text(
            label,
            style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final List<OptionMenuItem> options = [
      OptionMenuItem(
        text: '신고하기',
        icon: 'assets/icons/report.svg',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ReportScreen()),
        ),
      ),
      OptionMenuItem(
        text: '알림 끄기',
        icon: 'assets/icons/alarm.svg',
        onTap: () async {}, // TODO: 알림 끄기 기능 구현
      ),
      OptionMenuItem(
        text: '채팅방 나가기',
        icon: 'assets/icons/exit.svg',
        onTap: () async {
          final result = await ConfirmDialog.show(
            context: context,
            title: '채팅방을 나가시겠습니까?',
            content: '채팅방의 내용은 복구되지 않으며, 삭제됩니다',
            confirmText: '채팅방 나가기'
          );

          if (result) {
            // TODO: 채팅방 나가기 구현
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatListScreen()));
          }
        },
      ),
    ];

    OptionsMenu.show(context: context, options: options);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isSameTime(DateTime time1, DateTime time2) {
    return time1.year == time2.year &&
        time1.month == time2.month &&
        time1.day == time2.day &&
        time1.hour == time2.hour &&
        time1.minute == time2.minute;
  }
}

class _DateDivider extends StatelessWidget {
  final DateTime date;

  const _DateDivider({
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Text(
          _formatDate(date),
          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekDays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekDay = weekDays[date.weekday - 1];
    return '${date.year}년 ${date.month}월 ${date.day}일 $weekDay요일';
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTime;
  final String opponentProfileUrl;

  const _MessageBubble({
    required this.message,
    required this.showTime,
    required this.opponentProfileUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == 'user1'; // TODO: AuthProvider에서 현재 사용자 ID를 가져와야 함

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _buildProfileImage(),
              if (isMe && showTime) _buildTimeIndicator(isMe: true),
              _buildMessageContent(isMe),
              if (!isMe && showTime) _buildTimeIndicator(isMe: false),
            ],
          ),
        ),
      ),
    );
  }
  
  // 프로필 이미지
  Widget _buildProfileImage() {
    return Container(
      width: 40.w,
      height: 40.w,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(opponentProfileUrl),
          fit: BoxFit.cover,
        ),
        color: GRAY200_COLOR,
      ),
    );
  }
  
  // 시간 표시
  Widget _buildTimeIndicator({required bool isMe}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.createdAt),
          style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),
        ),
        if (isMe) 4.horizontalSpace else 4.horizontalSpace,
      ],
    );
  }
  
  // 메시지 내용
  Widget _buildMessageContent(bool isMe) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200.w),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.messageType == 'IMAGE')
            _buildImageMessage()
          else if (message.messageType == 'TEXT')
            _buildTextMessage(isMe),
        ],
      ),
    );
  }
  
  // 이미지 메시지
  Widget _buildImageMessage() {
    return GestureDetector(
      onTap: () {
        // 이미지 상세보기
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          message.content,
          width: 200.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  
  // 텍스트 메시지
  Widget _buildTextMessage(bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isMe ? BLUE400_COLOR : GRAY100_COLOR,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20).r,
                bottomRight: Radius.circular(20).r,
                bottomLeft: Radius.circular(20).r,
              )
            : BorderRadius.only(
                topRight: Radius.circular(20).r,
                bottomRight: Radius.circular(20).r,
                bottomLeft: Radius.circular(20).r,
              ),
      ),
      child: Text(
        message.content,
        style: AppTextStyles.body1.copyWith(
          color: isMe ? WHITE100_COLOR : GRAY800_COLOR,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final formattedHour = (hour > 12 ? hour - 12 : hour).toString();
    return '$period $formattedHour:$minute';
  }
}
