import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingalone/chat/models/message_model.dart';
import 'package:livingalone/chat/view/chat_list_screen.dart';
import 'package:livingalone/chat/view_models/chat_list_provider.dart';
import 'package:livingalone/chat/view_models/chat_room_provider.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/component/options_menu.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String opponentName;
  final String opponentProfileUrl;

  const ChatRoomScreen({
    required this.roomId,
    required this.opponentName,
    required this.opponentProfileUrl,
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
      ref
          .read(chatMessagesProvider(widget.roomId).notifier)
          .sendImage(image.path);
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
    final messages = ref.watch(chatMessagesProvider(widget.roomId));

    return DefaultLayout(
      title: widget.opponentName,
      actions: IconButton(
          onPressed: () => _showOptionsMenu(context),
          icon: Icon(Icons.more_horiz_rounded)),
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
                  //TODO: 게시글 내용 부분 이벤트 처리 및 텍스트 넣기
                ],
              ),
            ),
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Text(
                        '메시지가 없습니다.',
                        style:
                            AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        final showDate = index == messages.length - 1 ||
                            !_isSameDay(
                              message.timestamp,
                              messages[messages.length - 2 - index].timestamp,
                            );

                        final showTime = index == 0 || // 가장 최근 메시지
                            !_isSameTime(
                              message.timestamp,
                              messages[messages.length - index].timestamp,
                            ) || message.isMe != messages[messages.length - index].isMe; // 이전 메시지와 보낸 사람이 다름


                        return Column(
                          children: [
                            if (showDate) _DateDivider(date: message.timestamp),
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    duration: Duration(milliseconds: 200), // 애니메이션 지속 시간
                    curve: Curves.easeOut, // 부드러운 애니메이션 적용
                    height: MediaQuery.of(context).viewInsets.bottom == 0
                        ? 34.h
                        : 0,
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
        text: '채팅방 나가기',
        icon: 'assets/icons/edit.svg',
        onTap: () async {
          final result = await ConfirmDialog.show(
              context: context,
              title: '채팅방을 나가시겠습니까?',
              content: '채팅방의 내용은 복구되지 않으며, 삭제됩니다');

          if (result) {
            ref.read(chatRoomsProvider.notifier).leaveChatRoom(widget.roomId);
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
      // padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                        .read(chatMessagesProvider(widget.roomId).notifier)
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
              color: _messageController.text.trim().isEmpty
                  ? GRAY400_COLOR
                  : BLUE400_COLOR,
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
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
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
              if (!message.isMe) ...[
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
              if (message.isMe && showTime) ...[
                Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),
                ),
                4.horizontalSpace,
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.w),
                child: Column(
                  crossAxisAlignment: message.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message.imageUrl != null)
                      GestureDetector(
                        onTap: () {
                          // 이미지 상세보기
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            message.imageUrl!,
                            width: 200.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (message.content.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: message.isMe ? BLUE400_COLOR : GRAY100_COLOR,
                          borderRadius: message.isMe
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
                            color: message.isMe ? WHITE100_COLOR : GRAY800_COLOR,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!message.isMe && showTime) ...[
                4.horizontalSpace,
                Text(
                  _formatTime(message.timestamp),
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
