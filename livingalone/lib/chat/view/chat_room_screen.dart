import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _focusNode = FocusNode();
  bool _showKeyboard = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {});
    });
    // 읽음 처리
    ref.read(chatMessagesProvider.notifier).markAsRead(widget.roomId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      // TODO: 이미지 전송 구현
    }
  }

  void _toggleKeyboard() {
    setState(() {
      _showKeyboard = !_showKeyboard;
      if (_showKeyboard) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(chatMessageProvider(widget.roomId));

    return DefaultLayout(
      title: widget.opponentName,
      actions: IconButton(
        onPressed: () => _showOptionsMenu(context),
        icon: Icon(Icons.more_horiz_rounded),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Container(
              height: 72.h,
              padding: EdgeInsets.all(12).w,
              decoration: BoxDecoration(
                color: GRAY100_COLOR,
              ),
              child: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.chatRoom.title,
                          style: AppTextStyles.body2.copyWith(
                            color: GRAY800_COLOR,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
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
                            Text(
                              widget.chatRoom.location,
                              style: AppTextStyles.caption2.copyWith(
                                color: GRAY600_COLOR,
                              ),
                            ),
                            if (widget.chatRoom.type == 'ROOM') ...[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: 1.w,
                                height: 10.h,
                                color: GRAY400_COLOR,
                              ),
                              Text(
                                widget.chatRoom.buildingType ?? '',
                                style: AppTextStyles.caption2.copyWith(
                                  color: GRAY600_COLOR,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: 1.w,
                                height: 10.h,
                                color: GRAY400_COLOR,
                              ),
                              Text(
                                widget.chatRoom.monthlyRent != null
                                    ? '월세 ${widget.chatRoom.monthlyRent}'
                                    : widget.chatRoom.deposit != null
                                        ? '전세 ${widget.chatRoom.deposit}'
                                        : '',
                                style: AppTextStyles.caption2.copyWith(
                                  color: GRAY600_COLOR,
                                ),
                              ),
                            ] else if (widget.chatRoom.type == 'TICKET') ...[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: 1.w,
                                height: 10.h,
                                color: GRAY400_COLOR,
                              ),
                              Text(
                                widget.chatRoom.ticketType ?? '',
                                style: AppTextStyles.caption2.copyWith(
                                  color: GRAY600_COLOR,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: messageState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messageState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                messageState.error!,
                                style: AppTextStyles.body1.copyWith(
                                  color: ERROR_TEXT_COLOR,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(chatMessageProvider(widget.roomId).notifier).loadMessages();
                                },
                                child: Text('다시 시도'),
                              ),
                            ],
                          ),
                        )
                      : messageState.messages.isEmpty
                          ? Center(
                              child: Text(
                                '메시지가 없습니다.',
                                style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              reverse: false,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              itemCount: messageState.messages.length,
                              itemBuilder: (context, index) {
                                final message = messageState.messages[index];
                                final showDate = index == 0 ||
                                    !_isSameDay(
                                      message.createdAt,
                                      messageState.messages[index > 0 ? index - 1 : index].createdAt,
                                    );

                                final showTime = index == 0 || // 첫 메시지
                                    !_isSameTime(
                                      message.createdAt,
                                      messageState.messages[index > 0 ? index - 1 : index].createdAt,
                                    ) ||
                                    message.senderId != messageState.messages[index > 0 ? index - 1 : index].senderId;

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
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_showKeyboard)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.camera_alt,
                            label: '카메라',
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: Icons.image,
                            label: '앨범',
                            onTap: _pickImage,
                          ),
                          _buildActionButton(
                            icon: Icons.location_on,
                            label: '장소',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 10.h),
                    child: _buildCommentInput(),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    height: MediaQuery.of(context).viewInsets.bottom == 0 ? 34.h : 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final List<OptionMenuItem> options = [
      OptionMenuItem(
        text: '신고하기',
        icon: 'assets/icons/report.svg',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ReportScreen()),
          );
        },
      ),
      OptionMenuItem(
        text: '알림 끄기',
        icon: 'assets/icons/alarm.svg',
        onTap: () async {},
      ),
      OptionMenuItem(
        text: '채팅방 나가기',
        icon: 'assets/icons/exit.svg',
        onTap: () async {
          final result = await ConfirmDialog.show(
            context: context,
            title: '채팅방을 나가시겠습니까?',
            content: '채팅방의 내용은 복구되지 않으며, 삭제됩니다',
          );

          if (result) {
            // TODO: 채팅방 나가기 구현
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatListScreen()));
          }
        },
      ),
    ];

    OptionsMenu.show(
      context: context,
      options: options,
    );
  }

  Widget _buildCommentInput() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: GRAY100_COLOR,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        controller: _messageController,
        focusNode: _focusNode,
        style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(
              _showKeyboard ? Icons.add : Icons.close,
              color: GRAY600_COLOR,
            ),
            onPressed: _toggleKeyboard,
          ),
          suffixIcon: IconButton(
            onPressed: _messageController.text.trim().isEmpty
                ? null
                : () {
                    ref
                        .read(chatMessageProvider(widget.roomId).notifier)
                        .sendMessage(_messageController.text.trim());
                    _messageController.clear();
                    _scrollToBottom();
                  },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 24.w,
              minHeight: 24.h,
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            ),
            icon: Icon(
              Icons.arrow_circle_up_rounded,
              color: _messageController.text.trim().isEmpty ? GRAY400_COLOR : BLUE400_COLOR,
              size: 24.w,
            ),
          ),
          hintText: '메시지를 입력하세요',
          hintStyle: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
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
              color: GRAY100_COLOR,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: GRAY600_COLOR),
          ),
          4.verticalSpace,
          Text(
            label,
            style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
          ),
        ],
      ),
    );
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
        margin: EdgeInsets.only(
          top: 4.h,
          bottom: 4.h,
        ),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                Container(
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
                ),
              ],
              if (isMe && showTime) ...[
                Text(
                  _formatTime(message.createdAt),
                  style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),
                ),
                4.horizontalSpace,
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.w),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (message.messageType == 'IMAGE')
                      GestureDetector(
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
                      ),
                    if (message.messageType == 'TEXT')
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
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
                      ),
                  ],
                ),
              ),
              if (!isMe && showTime) ...[
                4.horizontalSpace,
                Text(
                  _formatTime(message.createdAt),
                  style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),
                ),
              ],
            ],
          ),
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
