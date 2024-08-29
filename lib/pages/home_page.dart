import 'package:flutter/material.dart';
import 'package:medical_calculator/pages/answer.dart';

class HomePage extends StatelessWidget{
  final TextEditingController PH = TextEditingController();
  final TextEditingController P_CO2 = TextEditingController(), P_O2 = TextEditingController(); //分压
  final TextEditingController C_HCO3 = TextEditingController(), C_Na = TextEditingController(), C_K = TextEditingController(), C_Cl = TextEditingController(); //浓度
  final TextEditingController AG = TextEditingController();
  final TextEditingController ALB = TextEditingController(), HBG = TextEditingController();  //白蛋白,血红蛋白
  final TextEditingController Lac = TextEditingController();       //乳酸
  final TextEditingController TIME = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("血气分析[刘志霄专用版]"),
        backgroundColor: Colors.amber[50],
      ),
      backgroundColor: const Color.fromARGB(255, 193, 228, 240),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: PH,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'pH(必填)[正常范围：7.35-7.45]'),
              ),
              TextField(
                controller: P_CO2,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'p(CO₂)[mmHg] (必填)[正常范围：35-45]'),
              ),
              TextField(
                controller: P_O2,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'p(O₂)[mmHg] (必填)[正常范围：80-108]'),
              ),
              TextField(
                controller: C_HCO3,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'c(HCO₃⁻)[mmol/L] (必填)[正常范围：22-27]'),
              ),
              TextField(
                controller: C_Na,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'c(Na⁺)[mmol/L] (必填)[正常范围：[135-145]'),
              ),
              TextField(
                controller: C_K,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'c(K⁺)[mmol/L] (必填)[正常范围：3.5-5.5]'),
              ),
              TextField(
                controller: C_Cl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'c(Cl⁻)[mmol/L] (必填)[正常范围：[98-106]'),
              ),
              TextField(
                controller: ALB,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ALB[g/L] (可选，默认为41)[正常范围：[>40]'),
              ),
              TextField(
                controller: Lac,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Lac[mmol/L] (可选，默认为1.0)[正常范围：0.5-1.6]'),
              ),
              
              TextField(
                controller: TIME,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '出现时间[天] (必填)'),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    double ph = double.tryParse(PH.text) ?? 0;
                    double pCO2 = double.tryParse(P_CO2.text) ?? 0;
                    double pO2 = double.tryParse(P_O2.text) ?? 0;
                    double cHCO3 = double.tryParse(C_HCO3.text) ?? 0;
                    double cNa = double.tryParse(C_Na.text) ?? 0;
                    double cK = double.tryParse(C_K.text) ?? 0;
                    double cCl = double.tryParse(C_Cl.text) ?? 0;
                    double alb = double.tryParse(ALB.text) ?? 41;
                    
                    double lac = double.tryParse(Lac.text) ?? 1.0;
                    double time = double.tryParse(TIME.text) ?? 0;
                    //—————————————————————输出结果——————————————————————————
                    int IsAcute = 1;  //1：急性，0：慢性，-1：亚急性
                    int Acid_base_poisoning = 0;  //0：正常，1：酸中毒；2：可能的酸中毒；3：碱中毒；4：可能的碱中毒
                    int IsDaixie = -1; //-1:正常，1：代谢，2：呼吸
                    bool IsAgFine = true; //true：正常AG，false：高AG
                    String Addition = "";
                    //——————————————————————————————————————————————————————
                    int CO2_relations = 0;        //0:正常；1：二氧化碳减低；2：高碳酸血症
                    int HCO3_relations = 0;       //0:正常，1：偏低，2：偏高
                    double avg_HCO3 = 24;
                    bool EverythingIsOK = false;
                    bool Distinctly_abnormal = false;
                    int IsPHDown = -1;
                    int IsCO2Down = -1;
                    int IsHCO3Down = -1;  //-1表示正常
                    bool MergeAcidAndDaixie = false;  //如果合并了代酸，就需要看AG值是否为 高AG，如果为高AG就需要额外分析是否合并
                    bool Hypoproteinemia = false;
                    bool IsO2Fine = true;

                    double ag = cNa - cCl - cHCO3;
                    double derta_HCO3 = 24 - cHCO3;
                    double derta_AG;
                    double PredicAcutePH = 0.08*(pCO2-40)/10;
                    double PredicChronicPH = 0.03*(pCO2-40)/10;
                    double pha;
                    double differ = 12;


                    if (pO2 < 80)
                    {
                      IsO2Fine = false;
                    }
                    //乳酸 target!
                    String _lac = "";
                    if (lac < 0.5)
                    {
                      _lac = "乳酸水平较低";
                    }
                    else if (lac < 1.7)
                    {
                      _lac = "乳酸水平正常";
                    }
                    else if (lac < 2.5)
                    {
                      _lac = "乳酸水平略高";
                    }
                    else if (lac < 5.0)
                    {
                      _lac = "存在高乳酸血症";
                    } 
                    else
                    {
                      _lac = "存在乳酸性酸中毒";
                    }


                    if (pCO2 < 30 || pCO2 > 50 || cHCO3 < 20 || cHCO3 > 30)   //是否存在明显异常
                    {
                      Distinctly_abnormal = true;
                    }

                    if (Distinctly_abnormal)    //存在明显异常时
                    {
                      //酸碱中毒
                      if (ph < 7.35)
                      {
                        Acid_base_poisoning = 1;
                        IsPHDown = 1;
                      }
                      else if (ph < 7.4)
                      {
                        Acid_base_poisoning = 2;
                        IsPHDown = 1;
                      }
                      else if (ph < 7.45)
                      {
                        Acid_base_poisoning = 4;
                        IsPHDown = 0;
                      }
                      else
                      {
                        Acid_base_poisoning = 3;
                        IsPHDown = 0;
                      }

                      if (pCO2 <= 40)     //判断是否存在高碳酸血症
                      {
                        CO2_relations = 1;
                        IsCO2Down = 1;
                      }
                      else if (pCO2 > 40)
                      {
                        CO2_relations = 2;
                        IsCO2Down = 0;
                      }
                    }
                    else                        //不存在明显异常时
                    {
                      //酸碱中毒
                      if (ph < 7.35)
                      {
                        Acid_base_poisoning = 1;
                        IsPHDown = 1;
                      }
                      else if (ph > 7.45)
                      {
                        Acid_base_poisoning = 3;
                        IsPHDown = 0;
                      }

                      if (pCO2 < 35)      
                      {
                        CO2_relations = 1;
                        IsCO2Down = 1;
                      }
                      else if (pCO2 > 45)
                      {
                        CO2_relations = 2;
                        IsCO2Down = 0;
                      }
                    }
                    if (cHCO3 < 22)
                    {
                      IsHCO3Down = 1;
                      HCO3_relations = 1;
                    }
                    else if (cHCO3 > 27)
                    {
                      IsHCO3Down = 0;
                      HCO3_relations = 2;
                    }

                    if (Acid_base_poisoning == 0 && CO2_relations == 0 && HCO3_relations == 0)
                    {
                      EverythingIsOK = true;
                    }

                    if ((IsPHDown == 1 && IsCO2Down == 1) || (IsPHDown == 0 && IsCO2Down == 0))   //判断是代谢性还是呼吸性
                    {
                      IsDaixie = 1;
                    }
                    else if ((IsPHDown == 0 && IsCO2Down == 1) || (IsPHDown == 1 && IsCO2Down ==0))
                    {
                      IsDaixie = 0;
                    }
                    
                    
                    if (IsCO2Down == 0 && IsHCO3Down == 1)   //异向变化
                    {
                      Addition += " 代谢性酸中毒 ";
                      MergeAcidAndDaixie = true;
                    }
                    else if (IsCO2Down == 1 && IsHCO3Down == 0)
                    {
                      Addition += " 代谢性碱中毒 ";
                    }
                    else if ((IsCO2Down == 1 && IsHCO3Down == 1) || (IsCO2Down == 0 && IsHCO3Down == 0))//代偿
                    {
                      if (Acid_base_poisoning == 1)
                      {
                        if (IsDaixie == 1) //target  
                        {
                          if (pCO2 < (1.5*cHCO3)+6)
                          {
                            Addition += " 呼吸性碱中毒 ";
                          }
                          else if (pCO2 > (1.5*cHCO3)+10)
                          {
                            Addition += " 呼吸性酸中毒 ";
                          }
                        }
                        else if (IsDaixie == 0)
                        {
                          if (Distinctly_abnormal)
                          {
                            pha = (7.4-ph)/(pCO2/10);
                          }
                          else
                          {
                            pha = (7.35-ph)/(pCO2/10);
                          }
                          if (pha < PredicChronicPH)
                          {
                            IsAcute = 0;
                            if (cHCO3 > 24+0.4*(pCO2-40)+3)
                            {
                              Addition += " 代谢性碱中毒 ";
                            }
                            else if (cHCO3 < 24+0.4*(pCO2-40)-3)
                            {
                              Addition += " 代谢性酸中毒 ";
                            }
                          }
                          else if (pha < PredicAcutePH)
                          {
                            IsAcute = -1;
                            if ( (PredicAcutePH-PredicChronicPH-pha)/2 >= 0)
                            {
                              IsAcute = 1;
                            }
                            else
                            {
                              IsAcute = 0;
                            }
                          }
                          else
                          {
                            IsAcute = 1;
                            if (cHCO3 > 24+0.1*(pCO2-40)+3)   //target!
                            {
                              Addition += " 代谢性碱中毒 ";
                            }
                            else if(cHCO3 < 24+0.1*(pCO2-40)-3)
                            {
                              Addition += " 代谢性酸中毒 ";
                            }
                          }
                        }
                      }
                      else if (Acid_base_poisoning == 3)
                      {
                        if (IsDaixie == 1)   //target
                        {
                          if(pCO2 > (0.7*cHCO3)+23)
                          {
                            Addition += " 呼吸性酸中毒 ";
                          }
                          else if (pCO2 < (0.7*cHCO3)+19)
                          {
                            Addition += " 呼吸性碱中毒 ";
                          }
                        }
                        else if(IsDaixie == 0)
                        {
                          if (time < 10)    //判断是否急性的时间，暂定10天
                          {
                            IsAcute = 1;
                            if (cHCO3 < 24-0.2*(40-pCO2)-3)
                            {
                              Addition += " 代谢性酸中毒 ";
                              MergeAcidAndDaixie = true;
                            }
                            else if (cHCO3 > 24-0.2*(40-pCO2)+3)
                            {
                              Addition += " 代谢性碱中毒 ";
                            }
                          }
                          else
                          {
                            IsAcute = 0;
                            if (cHCO3 < 24-0.5*(40-pCO2)-3)
                            {
                              Addition += " 代谢性酸中毒 ";
                              MergeAcidAndDaixie = true;
                            }
                            else if (cHCO3 > 24-0.5*(40-pCO2)+3)
                            {
                              Addition += " 代谢性碱中毒 ";
                            }
                          }
                        }
                      }
                    }
                    
                    if (alb < 40)     //是否有低蛋白血症
                    {
                      Hypoproteinemia = true; 
                      differ = 12-(40-alb)*0.25;    //计算AG校正值
                      
                    }
                    if ((Acid_base_poisoning == 1 && IsDaixie == 1)|| MergeAcidAndDaixie)
                    {
                      if (ag > 16 )
                      {
                        IsAgFine = false;
                      }
                    }
                    if (MergeAcidAndDaixie||(IsDaixie == 1 && Acid_base_poisoning == 1) && !IsAgFine)    //当是 代谢性酸中毒(或合并了) 且 高AG 的情况
                    {
                      derta_AG = ag - differ;
                      if (derta_AG/derta_HCO3 < 1)
                      {
                        Addition += " 正常AG的代谢性酸中毒 "; //高AG代酸+正常AG代酸
                      }
                      else if (derta_AG/derta_HCO3 > 2)
                      {
                        Addition += " 代谢性碱中毒 ";   //高AG代酸+代碱
                      }
                    }

                    if (Addition == "")
                    {
                      Addition += "无";
                    }

                    String _IsAcute,_Acid_base_poisoning,_IsDaixie,_IsAgFine;
                    
                    if (IsAcute == 1)_IsAcute = "急性";
                    else if (IsAcute == 0) _IsAcute = "慢性";
                    else _IsAcute = "亚急性";

                    if (Acid_base_poisoning == 0)_Acid_base_poisoning = "未发现明显酸碱失衡";
                    else if (Acid_base_poisoning == 1)_Acid_base_poisoning = "酸中毒";
                    else if (Acid_base_poisoning == 2)_Acid_base_poisoning = "酸中毒";
                    else if (Acid_base_poisoning == 3)_Acid_base_poisoning = "碱中毒";
                    else _Acid_base_poisoning = "碱中毒";

                    if (IsDaixie == 1)_IsDaixie = "代谢性";
                    else if (IsDaixie == 0)_IsDaixie = "呼吸性";
                    else _IsDaixie = "";

                    if ((IsDaixie == 1 && Acid_base_poisoning == 1)||MergeAcidAndDaixie){
                      if (IsAgFine)_IsAgFine = "正常AG";
                      else _IsAgFine = "高AG";
                    }
                    else _IsAgFine = "";

                    if (EverythingIsOK)
                    {
                      _IsAcute=_Acid_base_poisoning=_IsDaixie=_IsAgFine="";
                      Addition = "未发现明显异常";
                    }

                    var answer = (_IsAcute,_Acid_base_poisoning,_IsDaixie,_IsAgFine,Addition,_lac);

                    Navigator.pushNamed(context,'/answer',arguments: answer);  //传递计算结果
                  },
                  child:const Text('Calculate'),
                )
              )
            ],
          ),
        ),
      )

      
    );
  }
}
