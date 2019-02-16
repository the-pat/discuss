import {Socket} from "phoenix";

const joinDiscussion = (socket) => (topicId) => {
  let channel = socket.channel(`discussion:${topicId}`, {});

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });
};

export default (window) => {
  const socket = new Socket("/socket", {params: {token: window.userToken}});
  socket.connect();

  return {
    joinDiscussion: joinDiscussion(socket)
  };
};
