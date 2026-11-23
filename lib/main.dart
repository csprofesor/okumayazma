import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MinikOkur());

const groups = [
 ['a','n','e','t','i','l'],
 ['o','k','u','r','ı','m'],
 ['ü','s','ö','y','d','z'],
 ['ç','b','g','c','ş'],
 ['p','h','v','ğ','f','j'],
];
const words = [
 ['an','ana','anne','Ela','Ali','at','el','al','tel','nine','nane'],
 ['okul','orman','kola','kule','mum','nar','limon','motor'],
 ['üzüm','süt','söz','yüz','deniz','zeytin'],
 ['çilek','çorap','bal','bebek','gemi','çiçek','şeker'],
 ['papatya','harita','vazo','fırın','yağmur','jilet'],
];
final tts = FlutterTts();
Future<void> speak(String s) async {
 await tts.setLanguage('tr-TR');
 await tts.setSpeechRate(.38);
 await tts.setPitch(1.05);
 await tts.awaitSpeakCompletion(true);
 await tts.speak(s);
}
Future<Set<String>> readProgress() async =>
 (await SharedPreferences.getInstance()).getStringList('done')?.toSet() ?? {};
Future<void> markDone(String s) async {
 final p = await SharedPreferences.getInstance();
 final v = p.getStringList('done') ?? [];
 if (!v.contains(s)) v.add(s);
 await p.setStringList('done', v);
}

class MinikOkur extends StatelessWidget {
 const MinikOkur({super.key});
 @override Widget build(BuildContext context) => MaterialApp(
  title:'Minik Okur', debugShowCheckedModeBanner:false,
  theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff3977c3)),scaffoldBackgroundColor:const Color(0xfff4f7fb)),
  home:const Home(),
 );
}
class Home extends StatefulWidget {
 const Home({super.key});
 @override State<Home> createState()=>_HomeState();
}
class _HomeState extends State<Home> {
 Set<String> done={}; int tab=0;
 @override void initState(){super.initState();load();}
 Future<void> load() async {done=await readProgress();if(mounted)setState((){});}
 @override Widget build(BuildContext context){
  final pages=[home(),Games(completed:done),const Writing(),const Parents()];
  return Scaffold(
   appBar:AppBar(title:const Text('Minik Okur',style:TextStyle(fontWeight:FontWeight.w900)),actions:[IconButton(onPressed:()=>speak('Merhaba minik okur. Birlikte okuyup yazmayı öğreneceğiz.'),icon:const Icon(Icons.volume_up))]),
   body:pages[tab],
   bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
    NavigationDestination(icon:Icon(Icons.home),label:'Ana Sayfa'),
    NavigationDestination(icon:Icon(Icons.extension),label:'Oyunlar'),
    NavigationDestination(icon:Icon(Icons.edit),label:'Yazı'),
    NavigationDestination(icon:Icon(Icons.family_restroom),label:'Veli'),
   ]),
  );
 }
 Widget home()=>ListView(padding:const EdgeInsets.all(18),children:[
  Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xff3977c3),Color(0xff69a9e6)]),borderRadius:BorderRadius.circular(26)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   const Text('Merhaba minik okur!',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w900)),
   const SizedBox(height:8),const Text('Her gün biraz pratik, kocaman bir ilerleme.',style:TextStyle(color:Colors.white)),
   const SizedBox(height:18),LinearProgressIndicator(value:done.length/29,minHeight:10,backgroundColor:Colors.white30,color:Colors.white),
   const SizedBox(height:7),Text('${done.length}/29 ses tamamlandı',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
  ])),
  const SizedBox(height:22),const Text('Öğrenme yolculuğum',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),
  ...List.generate(5,(i){ final unlocked=i==0||groups.take(i).every((g)=>g.every(done.contains)); final count=groups[i].where(done.contains).length; return Card(margin:const EdgeInsets.only(top:10),child:ListTile(
   leading:CircleAvatar(child:Icon(unlocked?Icons.looks_one:Icons.lock_outline)),title:Text('${i+1}. Ses Grubu',style:const TextStyle(fontWeight:FontWeight.bold)),
   subtitle:Text('${groups[i].join('  ·  ')}  •  $count/\${groups[i].length}'),trailing:Icon(unlocked?Icons.chevron_right:Icons.lock_outline),
   onTap:unlocked?()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GroupScreen(index:i,onDone:load))):null,
  ));}),
  const SizedBox(height:18),const Text('Hızlı erişim',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
  Row(children:[Expanded(child:Card(child:ListTile(leading:const Icon(Icons.hearing,color:Colors.orange),title:const Text('Harf oyunu'),onTap:()=>setState(()=>tab=1)))),Expanded(child:Card(child:ListTile(leading:const Icon(Icons.gesture,color:Colors.green),title:const Text('Yazı atölyesi'),onTap:()=>setState(()=>tab=2))))]),
 ]);
}
class GroupScreen extends StatefulWidget{
 final int index;final VoidCallback onDone;
 const GroupScreen({super.key,required this.index,required this.onDone});
 @override State<GroupScreen> createState()=>_GroupScreenState();
}
class _GroupScreenState extends State<GroupScreen>{
 Set<String> done={};
 @override void initState(){super.initState();refresh();}
 Future<void> refresh()async{done=await readProgress();if(mounted)setState((){});}
 @override Widget build(BuildContext context)=>Scaffold(
  appBar:AppBar(title:Text('${widget.index+1}. Ses Grubu')),
  body:ListView(padding:const EdgeInsets.all(18),children:[
   const Text('Harfleri sırayla öğren. Harf adına dokunarak dinle; kelimeleri de sesli tekrar et.',style:TextStyle(fontSize:16)),
   const SizedBox(height:16),
   GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:3,childAspectRatio:.9,children:groups[widget.index].map((l)=>Card(child:InkWell(borderRadius:BorderRadius.circular(20),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LetterScreen(letter:l,onDone:()async{await markDone(l);await refresh();widget.onDone();}))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Text(l,style:const TextStyle(fontSize:52,fontWeight:FontWeight.w900,color:Color(0xff3977c3))),
    Text(l.toUpperCase()),Icon(done.contains(l)?Icons.check_circle:Icons.play_circle_outline,color:done.contains(l)?Colors.green:Colors.grey),
   ])))).toList()),
   const SizedBox(height:16),
   FilledButton.icon(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>WordScreen(index:widget.index))),icon:const Icon(Icons.menu_book),label:const Text('Kelime oku')),
  ]),
 );
}
class LetterScreen extends StatelessWidget{
 final String letter;final Future<void> Function() onDone;
 const LetterScreen({super.key,required this.letter,required this.onDone});
 @override Widget build(BuildContext context){
  final samples=examples[letter]??[letter];
  return Scaffold(appBar:AppBar(title:Text('"$letter" sesini öğreniyorum')),body:ListView(padding:const EdgeInsets.all(18),children:[
   Container(height:180,decoration:BoxDecoration(color:const Color(0xffe7f1ff),borderRadius:BorderRadius.circular(24)),child:Center(child:Text(letter,style:const TextStyle(fontSize:125,fontWeight:FontWeight.w900,color:Color(0xff3977c3))))),
   const SizedBox(height:14),FilledButton.icon(onPressed:()=>speak('Bu harfin adı: ${letter.toUpperCase()}. Küçük harfi: $letter.'),icon:const Icon(Icons.volume_up),label:const Text('Harf adını dinle')),
   const SizedBox(height:20),const Text('Bu ses hangi kelimelerde var?',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
   ...samples.map((w)=>Card(child:ListTile(leading:Text(emoji(w),style:const TextStyle(fontSize:27)),title:Text(w,style:const TextStyle(fontSize:23,fontWeight:FontWeight.bold)),trailing:IconButton(icon:const Icon(Icons.volume_up),onPressed:()=>speak(w))))),
   const SizedBox(height:14),FilledButton(onPressed:()async{await onDone();if(context.mounted)Navigator.pop(context);},child:const Text('Bu sesi öğrendim')),
  ]));
 }
}
const examples={
 'a':['ana','at','al'],'n':['anne','nine','nane'],'e':['el','Ela','et'],'t':['at','tel','tat'],'i':['ile','Ali','il'],'l':['lale','el','Ali'],
 'o':['okul','ot','orman'],'k':['kek','kedi','okul'],'u':['un','kutu','uçak'],'r':['nar','ar','ır'],'ı':['ışık','ırmak'],'m':['mum','masa','limon'],
 'ü':['üzüm','süt','ütü'],'s':['su','sarı','ses'],'ö':['ördek','ödev','göz'],'y':['yol','yemek','ay'],'d':['dut','deniz','dede'],'z':['zil','zeytin','üzüm'],
 'ç':['çilek','çiçek','çorap'],'b':['bal','bebek','bal'],'g':['gemi','göz','gül'],'c':['cam','ceviz','ceket'],'ş':['şapka','şeker','kuş'],
 'p':['para','papatya','ip'],'h':['halı','horoz','hava'],'v':['vazo','ev','vişne'],'ğ':['dağ','yağmur','soğan'],'f':['fırın','fil','fare'],'j':['jet','judo','jilet']
};
String emoji(String w){
 if(w.contains('anne')||w.contains('ana'))return '👩';
 if(w.contains('at'))return '🐎';if(w.contains('inek'))return '🐄';if(w.contains('ördek'))return '🦆';
 if(w.contains('çilek'))return '🍓';if(w.contains('üzüm'))return '🍇';if(w.contains('çiçek'))return '🌼';
 if(w.contains('balık'))return '🐟';if(w.contains('araba'))return '🚗';if(w.contains('okul'))return '🏫';return '🔤';
}
const syllables=[
 ['an','en','et','al','el','il','at','it','la','na','ne','te'],
 ['ok','ol','on','un','ur','ar','ır','im','om','mur','kal','kol'],
 ['süt','söz','yüz','düz','saz','sor','dur','üz','öz','yol','dön'],
 ['bal','baş','gel','gül','çel','çok','kaç','baş','göz','güç'],
 ['fil','far','var','yap','par','fır','pır','jilet','vapur','pala'],
];
const sentences=[
 'Ela el ele.',
 'Ali okula iner.',
 'Dede üzüm alır.',
 'Çilek çok tatlı.',
 'Pelin harita yapar.',
];
class WordScreen extends StatelessWidget{
 final int index;const WordScreen({super.key,required this.index});
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Kelime zamanı')),body:ListView(padding:const EdgeInsets.all(18),children:[
 const Text('Kelimeye dokun ve dinle. Sonra kendin okumayı dene.',style:TextStyle(fontSize:16)),
 const SizedBox(height:14),
 const Text('Hece çalışması',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
 Wrap(spacing:8,runSpacing:8,children:syllables[index].map((s)=>ActionChip(label:Text(s,style:const TextStyle(fontSize:19,fontWeight:FontWeight.bold)),onPressed:()=>speak(s))).toList()),
 const SizedBox(height:16),
 const Text('Cümle okuyorum',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
 Card(child:ListTile(title:Text(sentences[index],style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),trailing:IconButton(onPressed:()=>speak(sentences[index]),icon:const Icon(Icons.volume_up)))),
 const SizedBox(height:12),
 ...words[index].map((w)=>Card(child:ListTile(leading:Text(emoji(w),style:const TextStyle(fontSize:28)),title:Text(w,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),trailing:IconButton(onPressed:()=>speak(w),icon:const Icon(Icons.volume_up))))),
 ]));
}
class Games extends StatefulWidget{
 final Set<String> completed;
 const Games({super.key,required this.completed});
 @override State<Games> createState()=>_GamesState();
}
class _GamesState extends State<Games>{
 final rng=Random();late String target;late List<String> options;int score=0;int? picked; late List<String> available;
 @override void initState(){super.initState();available=unlockedLetters();next();}
 List<String> unlockedLetters(){
  final result=<String>[];
  for(var i=0;i<groups.length;i++){
   if(i>0&&!groups[i-1].every(widget.completed.contains))break;
   result.addAll(groups[i]);
  }
  return result;
 }
 void next(){target=available[rng.nextInt(available.length)];options=[target];while(options.length<4){final x=available[rng.nextInt(available.length)];if(!options.contains(x))options.add(x);}options.shuffle();picked=null;setState((){});}
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Harf adını dinle ve doğru harfi bul!',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900)),
 Text('Puanın: $score'),const SizedBox(height:20),
 Container(height:130,decoration:BoxDecoration(color:const Color(0xffffefd9),borderRadius:BorderRadius.circular(24)),child:IconButton(iconSize:60,onPressed:()=>speak(target),icon:const Icon(Icons.volume_up))),
 const SizedBox(height:18),
 GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,children:options.map((x)=>Card(color:picked!=null&&x==target?const Color(0xffdff4e6):picked!=null&&options.indexOf(x)==picked?const Color(0xffffdddd):Colors.white,child:InkWell(onTap:picked!=null?null:(){setState((){picked=options.indexOf(x);if(x==target)score++;});speak(x==target?'Aferin, doğru!':'Tekrar dinleyelim.');},child:Center(child:Text(x,style:const TextStyle(fontSize:62,fontWeight:FontWeight.w900)))))).toList()),
 const SizedBox(height:16),FilledButton(onPressed:picked==null?()=>speak(target):next,child:Text(picked==null?'Sesi tekrar dinle':'Sonraki soru')),
 ]);
}
class Writing extends StatefulWidget{const Writing({super.key});@override State<Writing> createState()=>_WritingState();}
class _WritingState extends State<Writing>{
 String letter='a';List<Offset?> points=[];
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[
 const Text('Yazı atölyesi',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
 const Text('Harf modelini takip et. Parmağınla veya kalemle çiz.'),
 Wrap(spacing:6,children:groups.expand((g)=>g).map((l)=>ChoiceChip(label:Text(l),selected:letter==l,onSelected:(_)=>setState((){letter=l;points.clear();}))).toList()),
 Container(height:320,margin:const EdgeInsets.symmetric(vertical:14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:Colors.blueGrey.shade100)),
 child:LayoutBuilder(builder:(c,box)=>GestureDetector(onPanUpdate:(d)=>setState(()=>points.add(d.localPosition)),onPanEnd:(_)=>setState(()=>points.add(null)),child:CustomPaint(size:Size(box.maxWidth,box.maxHeight),painter:TracePainter(letter,points))))),
 OutlinedButton.icon(onPressed:()=>setState(()=>points.clear()),icon:const Icon(Icons.refresh),label:const Text('Yeniden yaz')),
 FilledButton.icon(onPressed:()=>speak('Şimdi $letter harfini yazıyoruz.'),icon:const Icon(Icons.volume_up),label:const Text('Yazılışı dinle')),
 ]);
}
class TracePainter extends CustomPainter{
 final String letter;final List<Offset?> points;TracePainter(this.letter,this.points);
 @override void paint(Canvas c,Size s){
  final grid=Paint()..color=const Color(0xffdce5ef)..strokeWidth=1;
  for(final y in [s.height*.3,s.height*.5,s.height*.7]){c.drawLine(Offset(0,y),Offset(s.width,y),grid);}
  final tp=TextPainter(text:TextSpan(text:letter,style:const TextStyle(fontSize:190,fontWeight:FontWeight.bold,color:Color(0x55a8bdd5))),textDirection:TextDirection.ltr)..layout();
  tp.paint(c,Offset((s.width-tp.width)/2,(s.height-tp.height)/2));
  final pen=Paint()..color=const Color(0xff3977c3)..strokeWidth=8..strokeCap=StrokeCap.round;
  for(var i=0;i<points.length-1;i++){if(points[i]!=null&&points[i+1]!=null)c.drawLine(points[i]!,points[i+1]!,pen);}
 }
 @override bool shouldRepaint(covariant TracePainter old)=>true;
}
class Parents extends StatelessWidget{
 const Parents({super.key});
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Veli köşesi',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
 const SizedBox(height:12),
 const Text('Uygulama, okulda öğretmen eşliğinde yürütülen ilk okuma yazma sürecini evde kısa tekrarlarla destekler.',style:TextStyle(fontSize:16,height:1.5)),
 const SizedBox(height:14),
 const Info(title:'Öğrenme sırası',body:'Ses farkındalığı → harf → hece → anlamlı kelime → cümle → kısa metin. Gruplar sırayla açılır. Harf adı ile harfin çıkardığı ses aynı şey değildir; doğru sesletim öğretmen rehberliğinde çalışılmalıdır.'),
 const Info(title:'Günlük çalışma',body:'Kısa ve düzenli tekrarlar yapın. Hız için zorlamayın; çocuğun öğrendiği seslerle hece ve kelime kurmasına fırsat verin. Olumlu geri bildirim kullanın.'),
 const Info(title:'Yazı çalışması',body:'Tırnaksız dik temel harfleri model alarak çalışın. Çocuğun el tercihini zorla değiştirmeyin.'),
 const Info(title:'Gizlilik',body:'Bu sürümde hesap, reklam, konum, kamera veya mikrofonla veri toplama yoktur. Öğrenme ilerlemesi cihazda saklanır.'),
 const SizedBox(height:12),const Text('Uygulama yardımcı öğrenme aracıdır; öğretmenin veya MEB ders kitabının yerini almaz.',style:TextStyle(fontWeight:FontWeight.bold)),
 ]);
}
class Info extends StatelessWidget{
 final String title,body;const Info({super.key,required this.title,required this.body});
 @override Widget build(BuildContext context)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.bold)),const SizedBox(height:6),Text(body,style:const TextStyle(height:1.4))])));
}
