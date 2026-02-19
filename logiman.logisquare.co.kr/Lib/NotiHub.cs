using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public class NotiHub : Hub
{
    //////////////////////////////////////
    //Hub class의 주요 이벤트 핸들러 재정의
    //////////////////////////////////////
    public override Task OnConnected()
    {
        return base.OnConnected();
    }

    public override Task OnDisconnected(bool stopCalled)
    {
        string lo_strjoinedUsers = string.Empty;
        var    connId      = Context.ConnectionId;
        var    user              = SignalRUsers._joinedUsers.FirstOrDefault(u => u.ConnectionId == connId);
/*
        if (user != null)
        {
            SignalRUsers._joinedUsers.Remove(user);

            lo_strjoinedUsers = JsonConvert.SerializeObject(SignalRUsers._joinedUsers);

            Clients.All.updateUserList(lo_strjoinedUsers);
        }
*/
        return base.OnDisconnected(stopCalled);
    }

    public override Task OnReconnected()
    {
        return base.OnReconnected();
    }
    //////////////////////////////////////
    //Hub class의 주요 이벤트 핸들러 재정의
    //////////////////////////////////////

    //////////////////////////////////////
    //제공할 커스텀 메소드 정의
    //////////////////////////////////////
    /// <summary>
    /// 웹소켓 사용자 등록
    /// </summary>
    /// <param name="SessionKey,">등록할 사용자 세션키</param>
    /// <param name="AdminID">등록할 사용자 아이디</param>
    /// <param name="AdminName">사용자 성명</param>
    /// <param name="MobileNo">사용자 전화번호</param>
    /// <returns></returns>
    public async Task JoinUser(string SessionKey, string AdminID, string AdminName, string MobileNo)
    {
        await Task.Run(() =>
        {
            if (!string.IsNullOrEmpty(AdminID))
            {
                //이미 등록이 되어 있으면 기존 정보 삭제
                /*
                var user = SignalRUsers._joinedUsers.FirstOrDefault(x => x.AdminID == AdminID);
                if (user != null)
                {
                    SignalRUsers._joinedUsers.Remove(user);
                }
                */

                SignalRUsers._joinedUsers.RemoveAll(x => x.AdminID == AdminID && x.SessionKey != SessionKey);
            }

            SignalRUsers._joinedUsers.Add(new User
            {
                ConnectionId = Context.ConnectionId,
                SessionKey   = SessionKey,
                AdminID      = AdminID,
                AdminName    = AdminName,
                MobileNo     = MobileNo
            });

            Clients.Caller.onJoined($"Hello {AdminID}, You joined as {AdminName} with {MobileNo}({Context.ConnectionId})");
        });
    }

    /// <summary>
    /// 현재 등록된 모든 사용자 정보 조회
    /// </summary>
    /// <returns></returns>
    public List<User> GetAllJoinedUsers()
    {
        return SignalRUsers._joinedUsers;
    }

    public async Task GetConnectedUsers()
    {
        await Task.Run(() =>
        {
            // 모든 유저 목록을 호출한 클라이언트에게 전송
            /*
            var users = SignalRUsers._joinedUsers.Select(u => new
            {
                u.AdminID,
                u.AdminName,
                u.MobileNo
            }).ToList();

            Clients.Caller.receiveUserList(users);
            */

            string lo_strjoinedUsers = JsonConvert.SerializeObject(SignalRUsers._joinedUsers);
            Clients.Caller.receiveUserList(lo_strjoinedUsers);
        });
    }

    /// <summary>
    /// 웹소켓 등록된 사용자 삭제
    /// **실제 웹소켓 종료의 경우 client에서 stop 메소드 호출
    /// </summary>
    /// <param name="AdminID">연결 해제할 사용자 아이디</param>
    /// <returns></returns>
    public async Task ExitUser(string AdminID)
    {
        await Task.Run(() =>
        {
            if (!string.IsNullOrEmpty(AdminID) && SignalRUsers._joinedUsers.Count > 0)
            {
                /*
                var user = SignalRUsers._joinedUsers.FirstOrDefault(x => x.AdminID == AdminID);
                if (user != null)
                {
                    SignalRUsers._joinedUsers.Remove(user);
                }
                */

                SignalRUsers._joinedUsers.RemoveAll(x => x.AdminID == AdminID);
            }
        });
    }

    /// <summary>
    /// 모든 사용자에게 메시지 전송
    /// </summary>
    /// <param name="message">전송할 메시지</param>
    /// <returns></returns>
    public Task BroadcastMessage(string message)
    {
        //Clients.Caller.receiveMessage("Hey caller! You sent " + message + "Is it right?", "Y");
        return Clients.All.receiveMessage(message, "Y");
    }

    /// <summary>
    /// 전송한 사용자 외 모든 사용자에게 메시지 전송
    /// </summary>
    /// <param name="AdminID">전송한 사용자 아이디</param>
    /// <param name="message">전송할 메시지</param>
    /// <returns></returns>
    public async Task SendMessage(string AdminID, string message)
    {
        await Task.Run(() =>
        {
            if (!string.IsNullOrEmpty(AdminID))
            {
                var user = SignalRUsers._joinedUsers.FirstOrDefault(x => x.AdminID == AdminID);
                if (user != null)
                {
                    Clients.AllExcept(user.ConnectionId).receiveMessage($"[{AdminID}]{message}", "N");
                }
                else
                {
                    Clients.All.receiveMessage($"[{AdminID}]{message}", "N");
                }
            }
            else
            {
                Clients.All.receiveMessage($"[{AdminID}]{message}", "N");
            }
        });
    }
    //////////////////////////////////////
    //제공할 커스텀 메소드 정의
    //////////////////////////////////////
}

public class User
{
    public string ConnectionId { get; set; }
    public string SessionKey   { get; set; }
    public string AdminID      { get; set; }
    public string AdminName    { get; set; }
    public string MobileNo     { get; set; }
}

public static class SignalRUsers
{
    public static List<User> _joinedUsers = new List<User>();
}