enum StepType {
  init(''),
  dataLoad('데이터로드'),
  authCheck('인증체크');

  const StepType(this.name);
  final String name;
}
