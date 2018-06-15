App.chat = null


# ビューの中にセットした値の取得
current_user_id = ->
  $('input:hidden[name="from_id"]').val()

user_id = ->
  $('input:hidden[name="to_id"]').val()

room_id = ->
  $('input:hidden[name="room_id"]').val()

# ルームIDの指定有無
room_ch = ->
  id = room_id()
  if id?
    return {channel: 'ChatChannel', room_id: id}
  else
    return null

# 出力先の特定
messages_height = ->
  temp = 0;
  $("div.message").each ->
    temp += ($(this).height());
  return temp

# リンクのクリックによりAjaxリクエストが呼ばれたら購読を解除
document.addEventListener 'turbolinks:request-start', ->
  if room_ch()?
    App.chat.unsubscribe()

# ページのロードが終わったら購読開始
document.addEventListener 'turbolinks:load', ->
  if room_ch()?
    App.chat = App.cable.subscriptions.create room_ch(),
      # 受診時の処理
      received: (data) ->
        $('#messages').append data['message']
        $('section.message_box').scrollTop(messages_height());

      # 送信時の処理
      speak: (from_id, to_id, room_id, content) ->
        #メソッド呼び出し
        @perform 'speak', {
          "from_id": from_id
          "to_id": to_id
          "room_id": room_id
          "content": content
        }

# Enterキーを押されたとき
$(document).on 'keypress', '[data-behavior~=chat_speaker]', (event) ->
  if event.which is 13
    value = event.target.value
    # 空白でないかつ50字以下
    if value.replace(/\s/g, '').length > 0 && value.length <= 50
      App.chat.speak(current_user_id(), user_id(), room_id(), value)
      event.target.value = ''
      event.preventDefault()
    else if value.length > 50
      alert("Message should be less than 51 characters.")
      event.target.value = ''
      event.preventDefault()
    else
      event.target.value = ''
      event.preventDefault()