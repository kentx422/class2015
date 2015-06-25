import java.text.DecimalFormat;import java.util.ArrayList;/** * パーセプトロンの収束定理 * */public class PerceptronConvergenceTheorem {  /* クラスω１の学習パターン：(x1, x2, x3) = (1.2, 0.2, -0.2)   * クラスω２の学習パターン：(x1, x2, x3) = (-0.5, -1.0, -1.5) */    final double X[] = { 1.2, 0.2, -0.2, -0.5, -1.0, -1.5 };  //X:学習パターン  final double THRESHHOLD = -2.0 / 5.0;                     //クラスω１とω２を識別する際の閾値  DecimalFormat df = new DecimalFormat("0.00");             //表示する桁数を設定    public static void main(String[] args) {    new PerceptronConvergenceTheorem();  }    public PerceptronConvergenceTheorem(){    //パーセプトロンの学習規則    PerceptronLearningRule(1.2, -7, 2);      //ρの値＝1.2，重みベクトルｗ(w0, w1) = (-7, 2)    PerceptronLearningRule(2.0, 11, 5);      //ρの値＝2.0，重みベクトルｗ(w0, w1) = (11, 5)    PerceptronLearningRule(3.6, -7, 2);      //ρの値＝3.6，重みベクトルｗ(w0, w1) = (-7, 2)  }    /*パーセプトロンの学習規則(正の定数ρ，重みベクトルｗのｗ０，重みベクトルｗのｗ１)*/  public void PerceptronLearningRule(double p, double w0, double w1){    double g;                     //識別関数，g(x) = w0 + w1 * x    int counter;                  //全パターンを正しく識別したかを判断する変数    ArrayList<Double> temp_w0       = new ArrayList<Double>();  //新しく重みベクトルｗを作成した際にｗ０の履歴を保存するリスト    ArrayList<Double> temp_w1       = new ArrayList<Double>();  //新しく重みベクトルｗを生成した際にｗ１の履歴を保存するリスト        System.out.println("ρの値＝"+ p +"，重みベクトルｗ＝（"+ df.format(w0) +"，"+ df.format(w1) +")");    System.out.println("学習パターン  識別関数g(x)  w0  w1");        temp_w0.add(w0);             //重みベクトルｗのｗ０の初期値を保存    temp_w1.add(w1);             //重みベクトルｗのｗ１の初期値を保存        /*全ての学習パターンにおいて識別を行う*/    while(true){                 //全ての学習パターンにおいて正しく識別できるまでループ      counter = 0;               //カウンターを初期化      for(int i = 0; i < X.length; i++){    //学習パターンの数だけループ                g = w0 + w1 * X[i];      //識別関数g(x)を算出        System.out.println(X[i] +"  "+ df.format(g) +"  "+ df.format(w0) +"  "+ df.format(w1));                /* 識別関数g(x) > 0 のとき，その学習パターンはクラスω１であると識別される         * 識別関数g(x) < 0 のとき，その学習パターンはクラスω２であると識別される * */          if(X[i] > THRESHHOLD){  //学習パターンが閾値以上であり，クラスω１であるか識別する場合          if(g > 0){                //学習パターンがクラスω１であると識別された場合            counter++;                //正しく識別されたため，counter をインクリメントする          }          else{                     //学習パターンがクラスω２であると識別された場合                              /* 正しく識別されなかったため，新たな重みベクトルｗ’を作成する             *クラスω１の学習パターンに対してクラスω２であると認識した場合             *新しい重みベクトルｗ’＝ 重みベクトルｗ ＋ 正の定数ρ となる*/                        w0 += p;                  //新しい重みベクトルｗ’のｗ’０を作成する            w1 += p * X[i];           //新しい重みベクトルｗ’のｗ’１を作成する            temp_w0.add(w0);          //新しい重みベクトルｗ’のｗ’０を保存する            temp_w1.add(w1);          //新しい重みベクトルｗ’のｗ’１を保存する          }        }                else{                     //学習パターンが閾値以下であり，クラスω２である識別する場合          if(g < 0){                //学習パターンがクラスω２であると識別された場合            counter++;                //正しく識別されたため，counter をインクリメントする          }          else{                     //学習パターンがクラスω１であると識別された場合                                          /*正しく識別されなかったため，新たな重みベクトルｗ’を作成する           *クラスω２の学習パターンに対してクラスω１であると認識した場合           *新しい重みベクトルｗ’ ＝ 重みベクトルｗ ー 正の定数ρ となる*/                        w0 -= p;                  //新しい重みベクトルｗ’のｗ’０を作成する            w1 -= p * X[i];           //新しい重みベクトルｗ’のｗ’１を作成する            temp_w0.add(w0);          //新しい重みベクトルｗ’のｗ’０を保存する            temp_w1.add(w1);          //新しい重みベクトルｗ’のｗ’１を保存する          }        }      }            if(counter == X.length){      //全ての学習パターンにおいて正しく識別された場合        break;                      //ループから抜ける      }    }        /*重みベクトルの初期値と新しく作成した重みベクトルを表示*/    System.out.println("学習パターン  w0  w1");    for(int i = 0; i < temp_w0.size(); i++){    //新しく作成した重みベクトルの数だけループ      System.out.println(df.format(temp_w0.get(i)) +"  "+ df.format(temp_w1.get(i)));    }    }  }