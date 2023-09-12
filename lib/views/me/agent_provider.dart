import 'package:E_Sale_Tech/api/me.dart';
import 'package:E_Sale_Tech/model/me/agent_info.dart';
import 'package:flutter/material.dart';

class AgentInfoProvider extends ChangeNotifier {
  AgentInfo _agentInfo = new AgentInfo();

  AgentInfo get agentInfo => _agentInfo;

  void setAgentInfo(AgentInfo data) {
    _agentInfo = data;
    notifyListeners();
  }

  void getAgentInfo() async {
    var data = await ApiMe.getAgentInfo();
    _agentInfo = data;
    notifyListeners();
  }
}
