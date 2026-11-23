import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MinikOkur());

// Official five sound groups; theme stages below follow the MEB first-grade teaching sequence.
const officialSoundGroups = [
 ['a','n','e','t','i','l'],
 ['o','k','u','r','ı','m'],
 ['ü','s','ö','y','d','z'],
 ['ç','b','g','c','ş'],
 ['p','h','v','ğ','f','j'],
];

// MEB theme progression: Theme 1 teaches a-n-e-t; Theme 2 completes i-l and begins o-k-u;
// Theme 3 completes group 2 and teaches group 3; Theme 4 teaches groups 4 and 5.
const groups = [
 ['a','n','e','t'],
 ['i','l','o','k','u'],
 ['r','ı','m','ü','s','ö','y','d','z'],
 ['ç','b','g','c','ş','p','h','v','ğ','f','j'],
];
const themeNames = [
 'Güzel Davranışlarımız',
 'Mustafa Kemal’den Atatürk’e',
 'Çevremizdeki Yaşam',
 'Yol Arkadaşımız Kitaplar',
];
String upperLetter(String letter) => const {
 'i':'İ','ı':'I','ö':'Ö','ü':'Ü','ç':'Ç','ş':'Ş','ğ':'Ğ',
 }[letter] ?? letter.toUpperCase();

const words = [
 ['an','ana','anne','at','et','ten','net','nane'],
 ['Ela','Ali','el','al','tel','nine','okul','ot','kek','kule','kutu','un','kola'],
 ['orman','mum','nar','limon','motor','üzüm','süt','söz','yüz','deniz','zeytin','ördek','yol','dede','ırmak','düdük'],
 ['çilek','çok','bal','bebek','gemi','çiçek','şeker','papatya','harita','vazo','fırın','yağmur','jilet','şapka','çorap'],
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
  ...List.generate(groups.length,(i){ final unlocked=i==0||groups.take(i).every((g)=>g.every(done.contains)); final count=groups[i].where(done.contains).length; return Card(margin:const EdgeInsets.only(top:10),child:ListTile(
   leading:CircleAvatar(child:unlocked?Text('${i+1}'):const Icon(Icons.lock_outline)),title:Text('Tema ${i+1}: ${themeNames[i]}',style:const TextStyle(fontWeight:FontWeight.bold)),
   subtitle:Text('${groups[i].join('  ·  ')}  •  $count/${groups[i].length}'),trailing:Icon(unlocked?Icons.chevron_right:Icons.lock_outline),
   onTap:unlocked?()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GroupScreen(index:i,onDone:load))):null,
  ));}),
  const SizedBox(height:18),const Text('Hızlı erişim',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
  Row(children:[Expanded(child:Card(child:ListTile(leading:const Icon(Icons.hearing,color:Colors.orange),title:const Text('Harf ve kelime oyunları'),onTap:()=>setState(()=>tab=1)))),Expanded(child:Card(child:ListTile(leading:const Icon(Icons.gesture,color:Colors.green),title:const Text('Yazı atölyesi'),onTap:()=>setState(()=>tab=2))))]),
  const SizedBox(height:10),
  Card(child:ListTile(
   leading:const Icon(Icons.menu_book_rounded,color:Color(0xff3977c3),size:30),
   title:const Text('Okuma Bahçesi',style:TextStyle(fontWeight:FontWeight.bold)),
   subtitle:Text(done.length==29?'Kısa hikâyeler ve anlama soruları':'Tüm harfleri tamamlayınca açılır'),
   trailing:Icon(done.length==29?Icons.chevron_right:Icons.lock_outline),
   onTap:done.length==29?()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReadingPage())):null,
  )),
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
  appBar:AppBar(title:Text('Tema ${widget.index+1}')),
  body:ListView(padding:const EdgeInsets.all(18),children:[
   const Text('Harfleri sırayla öğren. Harf adına dokunarak dinle; kelimeleri de sesli tekrar et.',style:TextStyle(fontSize:16)),
   const SizedBox(height:16),
   GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:3,childAspectRatio:.9,children:groups[widget.index].map((l)=>Card(child:InkWell(borderRadius:BorderRadius.circular(20),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LetterScreen(letter:l,onDone:()async{await markDone(l);await refresh();widget.onDone();}))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Text(l,style:const TextStyle(fontSize:52,fontWeight:FontWeight.w900,color:Color(0xff3977c3))),
    Text(upperLetter(l)),Icon(done.contains(l)?Icons.check_circle:Icons.play_circle_outline,color:done.contains(l)?Colors.green:Colors.grey),
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
  return Scaffold(appBar:AppBar(title:Text('"$letter" harfini öğreniyorum')),body:ListView(padding:const EdgeInsets.all(18),children:[
   Container(height:180,decoration:BoxDecoration(color:const Color(0xffe7f1ff),borderRadius:BorderRadius.circular(24)),child:Center(child:Text(letter,style:const TextStyle(fontSize:125,fontWeight:FontWeight.w900,color:Color(0xff3977c3))))),
   const SizedBox(height:14),FilledButton.icon(onPressed:()=>speak('Bu harfin adı: ${upperLetter(letter)}. Küçük harfi: $letter.'),icon:const Icon(Icons.volume_up),label:const Text('Harf adını dinle')),
   const SizedBox(height:12),const Text('Harf adı ile harfin çıkardığı ses farklıdır. Harfin sesini öğretmeninle çalış; aşağıdaki kelimeleri dinleyip tekrar et.',style:TextStyle(fontSize:15,height:1.4)),
   const SizedBox(height:12),const Text('Bu harf hangi kelimelerde var?',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
   ...samples.map((w)=>Card(child:ListTile(leading:illustration(w),title:Text(w,style:const TextStyle(fontSize:23,fontWeight:FontWeight.bold)),trailing:IconButton(icon:const Icon(Icons.volume_up),onPressed:()=>speak(w))))),
   const SizedBox(height:14),FilledButton(onPressed:()async{await onDone();if(context.mounted)Navigator.pop(context);},child:const Text('Bu sesi öğrendim')),
  ]));
 }
}
const examples={
 'a':['ana','at','an'],'n':['anne','nane','net'],'e':['et','ten','net'],'t':['at','et','ten'],'i':['ile','Ali','il'],'l':['lale','el','Ali'],
 'o':['okul','ot','on'],'k':['kek','okul','kola'],'u':['un','kutu','kul'],'r':['nar','ar','ır'],'ı':['ırmak','sarı','alır'],'m':['mum','masa','limon'],
 'ü':['üzüm','süt','ütü'],'s':['su','sarı','ses'],'ö':['ördek','ön','öz'],'y':['yol','yemek','ay'],'d':['dut','deniz','dede'],'z':['zil','zeytin','üzüm'],
 'ç':['çilek','çiçek','çok'],'b':['bal','bebek','bal'],'g':['gemi','göz','gül'],'c':['cam','ceviz','ceket'],'ş':['şeker','kuş','şişe'],
 'p':['para','papatya','ip'],'h':['halı','horoz','hava'],'v':['vazo','ev','vişne'],'ğ':['dağ','yağmur','soğan'],'f':['fırın','fil','fare'],'j':['jet','judo','jilet']
};
Widget illustration(String word){
 IconData icon=Icons.auto_awesome_rounded;
 if(word.contains('anne')||word.contains('ana')) icon=Icons.family_restroom_rounded;
 else if(word.contains('at')) icon=Icons.pets_rounded;
 else if(word.contains('ördek')||word.contains('balık')) icon=Icons.pets_rounded;
 else if(word.contains('çilek')||word.contains('üzüm')) icon=Icons.eco_rounded;
 else if(word.contains('çiçek')||word.contains('papatya')) icon=Icons.local_florist_rounded;
 else if(word.contains('araba')) icon=Icons.directions_car_rounded;
 else if(word.contains('okul')) icon=Icons.school_rounded;
 else if(word.contains('ev')||word.contains('kule')) icon=Icons.home_rounded;
 else if(word.contains('uçak')) icon=Icons.flight_rounded;
 else if(word.contains('su')||word.contains('süt')) icon=Icons.water_drop_rounded;
 else if(word.contains('vazo')) icon=Icons.local_florist_rounded;
 else if(word.contains('gemi')||word.contains('vapur')) icon=Icons.directions_boat_rounded;
 else if(word.contains('göz')) icon=Icons.visibility_rounded;
 else if(word.contains('şapka')||word.contains('çorap')) icon=Icons.checkroom_rounded;
 return Container(width:48,height:48,decoration:BoxDecoration(color:const Color(0xffffefd9),borderRadius:BorderRadius.circular(15)),child:Icon(icon,size:27,color:const Color(0xff3977c3)));
}

const syllables=[
 ['an','en','et','at','na','ne','ta','te','ten','net'],
 ['il','in','it','el','al','ol','on','ok','kol','kul','oku','ulu','ile','ela'],
 ['ur','ar','ır','im','om','mur','kal','kol','süt','söz','yüz','düz','saz','sor','dur','üz','öz','yol','dön'],
 ['bal','baş','gel','gül','çel','çok','kaç','göz','güç','fil','far','var','yap','par','fır','pır','jilet','vapur','pala'],
];
const sentences=[
 '',
 'Ali ile Ela el ele.',
 'Dede üzüm alır.',
 'Çilek çok tatlı.',
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
 if(sentences[index].isNotEmpty) Card(child:ListTile(title:Text(sentences[index],style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),trailing:IconButton(onPressed:()=>speak(sentences[index]),icon:const Icon(Icons.volume_up)))),
 const SizedBox(height:12),
 ...words[index].map((w)=>Card(child:ListTile(leading:illustration(w),title:Text(w,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),trailing:IconButton(onPressed:()=>speak(w),icon:const Icon(Icons.volume_up))))),
 ]));
}
class ReadingPassage{
 final String title;
 final String body;
 final String question;
 final List<String> options;
 final int answer;
 const ReadingPassage({required this.title,required this.body,required this.question,required this.options,required this.answer});
}
const readingPassages=[
 ReadingPassage(
  title:'Ali ve Küçük Kuş',
  body:'Sabah erkenden Ali bahçeye çıktı. Küçük bir kuş ağacın dalına kondu. Ali kuşa su verdi. Kuş neşeyle uçtu.',
  question:'Ali kuşa ne verdi?',
  options:['Su','Ekmek','Oyuncak'],
  answer:0,
 ),
 ReadingPassage(
  title:'Kitapta Neler Var?',
  body:'Zeynep ve Efe kitap okudu. Kitapta deniz, orman ve yıldızlar vardı. İkisi de yeni şeyler öğrendi.',
  question:'Kitapta hangileri vardı?',
  options:['Deniz, orman ve yıldızlar','Araba, tren ve uçak','Masa, sandalye ve dolap'],
  answer:0,
 ),
 ReadingPassage(
  title:'Minik Kaplumbağa',
  body:'Minik kaplumbağa yavaş yavaş ilerledi. Yolun sonunda gölgeli bir ağaç buldu. Ağacın altında dinlendi.',
  question:'Kaplumbağa nerede dinlendi?',
  options:['Ağacın altında','Denizde','Bir evin içinde'],
  answer:0,
 ),
];
class ReadingPage extends StatefulWidget{
 const ReadingPage({super.key});
 @override State<ReadingPage> createState()=>_ReadingPageState();
}
class _ReadingPageState extends State<ReadingPage>{
 int index=0;
 int? selected;
 bool checked=false;
 @override Widget build(BuildContext context){
  final passage=readingPassages[index];
  return Scaffold(
   appBar:AppBar(title:const Text('Okuma Bahçesi')),
   body:ListView(padding:const EdgeInsets.all(18),children:[
    const Text('Oku, dinle ve anladığını göster.',style:TextStyle(fontSize:16)),
    const SizedBox(height:12),
    Wrap(spacing:8,children:List.generate(readingPassages.length,(i)=>ChoiceChip(
     label:Text('Hikâye ${i+1}'),
     selected:index==i,
     onSelected:(_)=>setState((){index=i;selected=null;checked=false;}),
    ))),
    const SizedBox(height:14),
    Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
     Text(passage.title,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:Color(0xff3977c3))),
     const SizedBox(height:14),
     Text(passage.body,style:const TextStyle(fontSize:21,height:1.65,fontWeight:FontWeight.w500)),
     const SizedBox(height:14),
     FilledButton.icon(onPressed:()=>speak(passage.body),icon:const Icon(Icons.volume_up),label:const Text('Hikâyeyi dinle')),
    ]))),
    const SizedBox(height:12),
    Text(passage.question,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),
    const SizedBox(height:8),
    ...List.generate(passage.options.length,(i)=>Card(
     color:checked&&i==passage.answer?const Color(0xffdff4e6):checked&&i==selected?const Color(0xffffdddd):Colors.white,
     child:RadioListTile<int>(
      value:i,
      groupValue:selected,
      onChanged:checked?null:(v)=>setState(()=>selected=v),
      title:Text(passage.options[i],style:const TextStyle(fontSize:17)),
     ),
    )),
    const SizedBox(height:12),
    if(!checked) FilledButton(onPressed:selected==null?null:()=>setState(()=>checked=true),child:const Text('Cevabımı kontrol et')),
    if(checked) ...[
     Text(selected==passage.answer?'Harika! Hikâyeyi dikkatle okudun.':'Bir kez daha oku ve cevabı yeniden düşün.',style:TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:selected==passage.answer?Colors.green:Colors.deepOrange)),
     const SizedBox(height:8),
     OutlinedButton(onPressed:()=>setState((){selected=null;checked=false;}),child:const Text('Tekrar dene')),
    ],
   ]),
  );
 }
}
class Games extends StatefulWidget{
 final Set<String> completed;
 const Games({super.key,required this.completed});
 @override State<Games> createState()=>_GamesState();
}
class _GamesState extends State<Games>{
 final rng=Random();
 late String target;
 late List<String> options;
 late List<String> wordOptions;
 late List<String> available;
 int score=0;
 int? picked;
 bool wordMode=false;
 String? selectedWord;
 String? correctWord;

 @override void initState(){
  super.initState();
  available=unlockedLetters();
  prepareQuestion();
 }
 @override void didUpdateWidget(covariant Games oldWidget){
  super.didUpdateWidget(oldWidget);
  if(oldWidget.completed.length!=widget.completed.length||!oldWidget.completed.containsAll(widget.completed)){
   available=unlockedLetters();
   prepareQuestion();
  }
 }
 List<String> unlockedLetters(){
  final result=<String>[];
  for(var i=0;i<groups.length;i++){
   if(i>0&&!groups[i-1].every(widget.completed.contains))break;
   result.addAll(groups[i]);
  }
  return result;
 }
 int unlockedStageCount(){
  var count=1;
  for(var i=0;i<groups.length-1;i++){
   if(groups[i].every(widget.completed.contains)) count=i+2;
   else break;
  }
  return count;
 }
 void prepareQuestion(){
  target=available[rng.nextInt(available.length)];
  options=[target];
  while(options.length<4){
   final x=available[rng.nextInt(available.length)];
   if(!options.contains(x))options.add(x);
  }
  options.shuffle();
  final pool=words.take(unlockedStageCount()).expand((stage)=>stage).toList();
  final correct=pool.where((w)=>w.toLowerCase().contains(target)).toList();
  final wrong=pool.where((w)=>!w.toLowerCase().contains(target)).toList()..shuffle(rng);
  if(correct.isNotEmpty&&wrong.isNotEmpty){
   correctWord=correct[rng.nextInt(correct.length)];
   wordOptions=[correctWord!,...wrong.take(3)]..shuffle(rng);
  }else{
   correctWord=null;
   wordOptions=[];
  }
  picked=null;
  selectedWord=null;
 }
 void next(){prepareQuestion();setState((){});}
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
  const Text('Öğrenme oyunları',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900)),
  const SizedBox(height:12),
  SegmentedButton<bool>(
   segments:const [
    ButtonSegment(value:false,label:Text('Harf bul'),icon:Icon(Icons.abc_rounded)),
    ButtonSegment(value:true,label:Text('Kelimeyi bul'),icon:Icon(Icons.image_search_rounded)),
   ],
   selected:{wordMode},
   onSelectionChanged:(value){setState((){wordMode=value.first;prepareQuestion();});},
  ),
  const SizedBox(height:16),
  Text(wordMode?'İçinde bu harf bulunan kelimeyi seç.':'Harf adını dinle ve doğru harfi bul!',style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
  Text('Puanın: $score',style:const TextStyle(color:Colors.black54)),
  const SizedBox(height:16),
  Container(
   height:125,
   decoration:BoxDecoration(color:const Color(0xffffefd9),borderRadius:BorderRadius.circular(24)),
   child:Center(child:wordMode
    ?Text(target,style:const TextStyle(fontSize:76,fontWeight:FontWeight.w900,color:Color(0xff3977c3)))
    :IconButton(iconSize:60,onPressed:()=>speak(target),icon:const Icon(Icons.volume_up))),
  ),
  if(wordMode) ...[
   const SizedBox(height:8),
   Center(child:Text('“${upperLetter(target)}” harfini içeren resmi seç.',style:const TextStyle(fontWeight:FontWeight.w600))),
   const SizedBox(height:12),
   if(wordOptions.isNotEmpty) GridView.count(
    shrinkWrap:true,
    physics:const NeverScrollableScrollPhysics(),
    crossAxisCount:2,
    crossAxisSpacing:10,
    mainAxisSpacing:10,
    childAspectRatio:1.25,
    children:wordOptions.map((w)=>Card(
     color:selectedWord!=null&&w==correctWord?const Color(0xffdff4e6):selectedWord==w?const Color(0xffffdddd):Colors.white,
     child:InkWell(
      borderRadius:BorderRadius.circular(18),
      onTap:selectedWord!=null?null:(){
       setState((){selectedWord=w;if(w==correctWord)score++;});
       speak(w==correctWord?'Aferin! Bu kelimede ${upperLetter(target)} harfi var.':'Bir daha inceleyelim.');
      },
      child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
       illustration(w),
       const SizedBox(height:6),
       Text(w,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800)),
      ]),
     ),
    )).toList(),
   ) else const Text('Bu harf için yeterli kelime henüz açılmadı.'),
  ] else ...[
   const SizedBox(height:18),
   GridView.count(
    shrinkWrap:true,
    physics:const NeverScrollableScrollPhysics(),
    crossAxisCount:2,
    crossAxisSpacing:12,
    mainAxisSpacing:12,
    children:options.map((x)=>Card(
     color:picked!=null&&x==target?const Color(0xffdff4e6):picked!=null&&options.indexOf(x)==picked?const Color(0xffffdddd):Colors.white,
     child:InkWell(
      onTap:picked!=null?null:(){
       setState((){picked=options.indexOf(x);if(x==target)score++;});
       speak(x==target?'Aferin, doğru!':'Tekrar dinleyelim.');
      },
      child:Center(child:Text(x,style:const TextStyle(fontSize:62,fontWeight:FontWeight.w900))),
     ),
    )).toList(),
   ),
  ],
  const SizedBox(height:16),
  FilledButton(
   onPressed:wordMode
    ?(selectedWord==null?()=>speak('${upperLetter(target)} harfini içeren kelimeyi bul.'):next)
    :(picked==null?()=>speak(target):next),
   child:Text(wordMode
    ?(selectedWord==null?'Yönergeyi dinle':'Sonraki soru')
    :(picked==null?'Harf adını dinle':'Sonraki soru')),
  ),
 ]);
}
class Writing extends StatefulWidget{const Writing({super.key});@override State<Writing> createState()=>_WritingState();}
class _WritingState extends State<Writing>{
 String letter='a';bool uppercase=false;List<Offset?> points=[];
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[
 const Text('Yazı atölyesi',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
 const Text('Harf modelini takip et. Küçük ve büyük harf arasında geçiş yap; parmağınla veya kalemle çiz.'),
 Wrap(spacing:6,children:groups.expand((g)=>g).map((l)=>ChoiceChip(label:Text(l),selected:letter==l,onSelected:(_)=>setState((){letter=l;points.clear();}))).toList()),
 const SizedBox(height:8),
 Wrap(spacing:8,children:[
  ChoiceChip(label:const Text('Küçük harf'),selected:!uppercase,onSelected:(_)=>setState(()=>uppercase=false)),
  ChoiceChip(label:const Text('Büyük harf'),selected:uppercase,onSelected:(_)=>setState(()=>uppercase=true)),
 ]),
 Container(height:320,margin:const EdgeInsets.symmetric(vertical:14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:Colors.blueGrey.shade100)),
 child:LayoutBuilder(builder:(c,box)=>GestureDetector(onPanUpdate:(d)=>setState(()=>points.add(d.localPosition)),onPanEnd:(_)=>setState(()=>points.add(null)),child:CustomPaint(size:Size(box.maxWidth,box.maxHeight),painter:TracePainter(uppercase?upperLetter(letter):letter,points))))),
 OutlinedButton.icon(onPressed:()=>setState(()=>points.clear()),icon:const Icon(Icons.refresh),label:const Text('Yeniden yaz')),
 FilledButton.icon(onPressed:()=>speak('Şimdi ${uppercase?'büyük':'küçük'} $letter harfini yazıyoruz.'),icon:const Icon(Icons.volume_up),label:const Text('Yazılışı dinle')),
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
