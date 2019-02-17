import {Socket} from "phoenix";

const renderComments = (listElement) => (comments) => {
  if (!comments || comments.length === 0) {
    return;
  }

  const commentElements =
    comments.map(commentTemplate);

  listElement.innerHTML = commentElements.join('');
  listElement.classList.remove('hide');
};
const renderComment = (listElement) => (comment) => {
  const commentElement = commentTemplate(comment);

  listElement.innerHTML += commentElement;
  listElement.classList.remove('hide');
};

const commentTemplate = (comment) => `<li class="collection-item">${comment.content}</li>`;

const joinDiscussion = (socket) => (topicId, {textElement, clickElement, listElement}) => {
  const channel = socket.channel(`discussion:${topicId}`, {});

  channel.join()
    .receive('ok', resp => {
      renderComments(listElement)(resp.comments);
    })
    .receive('error', resp => {
      console.log("Unable to join", resp);
    });

  channel.on(`discussion:${topicId}:new`, resp => {
    renderComments(listElement)(resp.comment);
  });

  clickElement.addEventListener('click', () => {
    const content = textElement.value;
    channel.push('discussion:comment', { content });
    textElement.value = '';
  });

  return {
    joinDiscussion: joinDiscussion(socket)
  };
};

export default (window) => {
  const socket = new Socket("/socket", {params: {token: window.userToken}});
  socket.connect();

  return {
    joinDiscussion: joinDiscussion(socket)
  };
};
