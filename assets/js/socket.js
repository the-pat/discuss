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

const commentTemplate = (comment) => {
  let email = 'anonymous';
  if (comment.user) {
    email = comment.user.email;
  }

  return `
    <li class="collection-item">
      ${comment.content}
      <div class="secondary-content">${email}</div>
    </li>`;
};

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
    renderComment(listElement)(resp.comment);
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
  const params = {};
  if (window.userToken) {
    params.token = window.userToken;
  }

  const socket = new Socket("/socket", {params});
  socket.connect();

  return {
    joinDiscussion: joinDiscussion(socket)
  };
};
