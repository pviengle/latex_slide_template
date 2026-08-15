# Slide Template — Manual / คู่มือการใช้งาน

**English and ไทย.** Every section appears in both languages: English first, Thai second.
**ภาษาอังกฤษและภาษาไทย** ทุกหัวข้อมีสองภาษา ภาษาอังกฤษก่อน แล้วตามด้วยภาษาไทย

---

## 1. What this is / นี่คืออะไร

**EN.** This folder makes presentation slides. You write the words in a plain text file, and the computer turns them into a PDF you can present from. It is not PowerPoint — there is nothing to drag around. You type, you run one command, you get a finished PDF.

The upside: every slide looks the same without any effort, maths and code come out properly, and the files are plain text so they work well with version history.

**TH.** โฟลเดอร์นี้ใช้สร้างสไลด์นำเสนอ คุณพิมพ์เนื้อหาลงในไฟล์ข้อความธรรมดา แล้วคอมพิวเตอร์จะแปลงให้เป็นไฟล์ PDF ที่ใช้นำเสนอได้ ระบบนี้ไม่ใช่ PowerPoint จึงไม่มีการลากวางกล่องข้อความ คุณแค่พิมพ์ สั่งทำงานหนึ่งคำสั่ง แล้วก็ได้ไฟล์ PDF ที่เสร็จสมบูรณ์

ข้อดีคือ ทุกสไลด์จะหน้าตาเหมือนกันโดยไม่ต้องจัดเอง สมการและโค้ดจะแสดงผลถูกต้อง และไฟล์เป็นข้อความธรรมดาจึงเก็บประวัติการแก้ไขได้ง่าย

---

## 2. What you need / สิ่งที่ต้องมี

**EN.** One program: **TeX Live**. It is free. It includes everything else this template needs — you do not have to install any fonts or extra packages.

- Windows and macOS: download from <https://tug.org/texlive/>
- macOS users often prefer **MacTeX**, which is TeX Live packaged for Mac: <https://tug.org/mactex/>

To check it is installed, open a terminal and type `latexmk -v`. If you see a version number, you are ready.

**TH.** ต้องมีโปรแกรมเดียวคือ **TeX Live** ซึ่งใช้งานได้ฟรี และมีทุกอย่างที่เทมเพลตนี้ต้องใช้อยู่แล้ว คุณไม่ต้องติดตั้งฟอนต์หรือแพ็กเกจเพิ่มเติมใด ๆ

- Windows และ macOS: ดาวน์โหลดที่ <https://tug.org/texlive/>
- ผู้ใช้ macOS ส่วนใหญ่นิยมใช้ **MacTeX** ซึ่งคือ TeX Live ที่จัดชุดมาสำหรับ Mac: <https://tug.org/mactex/>

วิธีตรวจสอบว่าติดตั้งแล้ว ให้เปิดหน้าต่างคำสั่ง (Terminal) แล้วพิมพ์ `latexmk -v` ถ้าขึ้นเลขเวอร์ชันแสดงว่าพร้อมใช้งาน

---

## 3. Try it right now / ลองใช้งานทันที

**EN.** There is a finished example deck included, called `showcase`. Build it to check everything works.

**TH.** มีตัวอย่างสไลด์ที่ทำเสร็จแล้วชื่อ `showcase` ให้ลองสร้างดูเพื่อตรวจสอบว่าทุกอย่างทำงานได้

**Windows**
```powershell
.\scripts\build.ps1 -Deck showcase
```

**macOS / Linux**
```bash
./scripts/build.sh -d showcase
```

**EN.** The PDF appears at `build/showcase.pdf`. Open it — you will see every feature this template offers.

**TH.** ไฟล์ PDF จะไปอยู่ที่ `build/showcase.pdf` เปิดดูได้เลย ในไฟล์นั้นจะแสดงความสามารถทั้งหมดของเทมเพลตนี้

> **macOS note / หมายเหตุสำหรับ macOS:** the first time, you may need to allow the scripts to run:
> `chmod +x scripts/*.sh`
> ครั้งแรกอาจต้องอนุญาตให้สคริปต์ทำงานก่อน ด้วยคำสั่งข้างบน

---

## 4. Start your own talk / เริ่มทำสไลด์ของคุณเอง

**EN.** Do not copy files by hand. Run one command and it sets everything up for you.

**TH.** ไม่ต้องคัดลอกไฟล์เอง ใช้คำสั่งเดียวแล้วระบบจะจัดเตรียมให้ทั้งหมด

**Windows**
```powershell
.\scripts\new-deck.ps1 -Name my-talk
.\scripts\new-deck.ps1 -Name my-talk -Thai        # if it will contain Thai
```

**macOS / Linux**
```bash
./scripts/new-deck.sh -n my-talk
./scripts/new-deck.sh -n my-talk -t               # if it will contain Thai
```

**EN.** This creates a folder `decks/my-talk/`. Then:

1. Open `decks/my-talk/metadata.tex` and put in your title, name and department.
2. Write your slides in `decks/my-talk/sections/`.
3. Build it, the same way as the example above.

**TH.** คำสั่งนี้จะสร้างโฟลเดอร์ `decks/my-talk/` จากนั้น

1. เปิดไฟล์ `decks/my-talk/metadata.tex` แล้วใส่ชื่อเรื่อง ชื่อคุณ และหน่วยงาน
2. เขียนสไลด์ในโฟลเดอร์ `decks/my-talk/sections/`
3. สั่งสร้างไฟล์แบบเดียวกับตัวอย่างข้างบน

**EN.** Use `-Thai` / `-t` if the talk has any Thai in it. It turns on Thai support and picks the right settings automatically. You can also turn it on later by hand — see section 7.

**TH.** ให้ใช้ `-Thai` หรือ `-t` ถ้าสไลด์มีภาษาไทย ตัวเลือกนี้จะเปิดการรองรับภาษาไทยและตั้งค่าที่ถูกต้องให้อัตโนมัติ หรือจะเปิดใช้เองภายหลังก็ได้ ดูหัวข้อ 7

---

## 5. Writing a slide / การเขียนสไลด์

**EN.** One slide looks like this. `frame` is the word this system uses for a slide.

**TH.** สไลด์หนึ่งหน้าเขียนแบบนี้ คำว่า `frame` คือคำที่ระบบนี้ใช้เรียกสไลด์หนึ่งหน้า

```latex
\begin{frame}{The title of this slide}
  \begin{itemize}
    \item First point
    \item Second point
  \end{itemize}
\end{frame}
```

**EN.** A few things you will use often:

| What you want | What you type |
|---|---|
| A new section | `\section{Method}` |
| Bold, coloured emphasis | `\hl{important}` |
| Grey, played-down text | `\muted{minor detail}` |
| A red warning word | `\alert{careful}` |
| Two columns | `\twocol{left side}{right side}` |
| A slide with one big sentence | `\statementframe{The main result}` |
| A boxed statement | `\begin{block}{Title} ... \end{block}` |
| Points appearing one at a time | `\item<1->` `\item<2->` `\item<3->` |

**TH.** สิ่งที่ใช้บ่อย

| สิ่งที่ต้องการ | สิ่งที่ต้องพิมพ์ |
|---|---|
| ขึ้นหัวข้อใหม่ | `\section{วิธีการ}` |
| เน้นข้อความ ตัวหนามีสี | `\hl{สำคัญ}` |
| ข้อความสีเทา ลดความเด่น | `\muted{รายละเอียดย่อย}` |
| คำเตือนสีแดง | `\alert{ระวัง}` |
| แบ่งสองคอลัมน์ | `\twocol{ฝั่งซ้าย}{ฝั่งขวา}` |
| สไลด์ประโยคเดียวตัวใหญ่ | `\statementframe{ผลลัพธ์หลัก}` |
| ข้อความในกรอบ | `\begin{block}{หัวข้อ} ... \end{block}` |
| ให้หัวข้อทยอยขึ้นทีละข้อ | `\item<1->` `\item<2->` `\item<3->` |

> **EN — one rule to remember:** if a slide contains computer code, you must write `\begin{frame}[fragile]` instead of `\begin{frame}`. Without the word `fragile`, the build fails with a confusing message. This is a quirk of the slide system, not a mistake in this template.
>
> **TH — กฎข้อเดียวที่ต้องจำ:** ถ้าสไลด์มีโค้ดโปรแกรม ต้องเขียน `\begin{frame}[fragile]` แทน `\begin{frame}` ถ้าไม่ใส่คำว่า `fragile` การสร้างไฟล์จะล้มเหลวพร้อมข้อความที่อ่านไม่รู้เรื่อง นี่เป็นข้อจำกัดของระบบสไลด์เอง ไม่ใช่ข้อผิดพลาดของเทมเพลตนี้

---

## 6. Thai text / ข้อความภาษาไทย

**EN.** Thai works, and the font used is **Sarabun** — the same typeface as TH Sarabun New, the Thai government standard. The font files are stored inside this folder, so nothing needs installing and it works on any computer you copy this to.

There are two ways to write Thai:

**TH.** ระบบรองรับภาษาไทย และใช้ฟอนต์ **Sarabun** ซึ่งเป็นฟอนต์เดียวกับ TH Sarabun New ที่เป็นฟอนต์มาตรฐานราชการไทย ไฟล์ฟอนต์ถูกเก็บไว้ในโฟลเดอร์นี้แล้ว จึงไม่ต้องติดตั้งอะไรเพิ่ม และใช้งานได้บนคอมพิวเตอร์ทุกเครื่องที่คุณคัดลอกโฟลเดอร์นี้ไป

การเขียนภาษาไทยมีสองวิธี

```latex
% A few Thai words inside an English sentence
% คำไทยไม่กี่คำแทรกในประโยคภาษาอังกฤษ
The word \thaiinline{ตัวอย่าง} means "example".

% A whole paragraph in Thai
% ย่อหน้าภาษาไทยทั้งย่อหน้า
\begin{thaipar}
  สวัสดีครับ นี่คือข้อความภาษาไทย
\end{thaipar}
```

> **EN — important:** Thai in a **slide title** must be wrapped too. The heading font has no Thai letters in it, so unwrapped Thai comes out as empty boxes.
>
> ✅ `\begin{frame}{Results / \thaiinline{ผลลัพธ์}}`
> ❌ `\begin{frame}{Results / ผลลัพธ์}`
>
> **TH — ข้อควรระวัง:** ภาษาไทยที่อยู่ใน**หัวเรื่องสไลด์**ต้องครอบด้วย `\thaiinline{}` เช่นกัน เพราะฟอนต์ที่ใช้ทำหัวเรื่องไม่มีตัวอักษรไทย ถ้าไม่ครอบจะแสดงเป็นกล่องสี่เหลี่ยมว่าง ๆ

---

## 7. The two build modes / โหมดการสร้างไฟล์สองแบบ

**EN.** There are two ways the computer can turn your text into a PDF. This template supports both, and you rarely need to think about it — but there is one case where it matters.

| Mode | Speed | Thai font |
|---|---|---|
| **pdfLaTeX** (default) | Faster | Falls back to **Garuda** |
| **XeLaTeX** | A little slower | Real **Sarabun** |

The reason: Sarabun is a modern font file, and pdfLaTeX is old enough that it cannot read modern font files at all. So **if you want real Sarabun, the talk must be built with XeLaTeX.**

If you created the deck with `-Thai` / `-t`, this is already set for you and you can ignore all of it. To switch it on by hand, open `decks/<your-talk>/.latexmkrc` and remove the `#` from this line:

**TH.** คอมพิวเตอร์แปลงข้อความของคุณเป็น PDF ได้สองวิธี เทมเพลตนี้รองรับทั้งสองแบบ และโดยปกติคุณไม่ต้องสนใจ แต่มีกรณีหนึ่งที่สำคัญ

| โหมด | ความเร็ว | ฟอนต์ไทย |
|---|---|---|
| **pdfLaTeX** (ค่าเริ่มต้น) | เร็วกว่า | เปลี่ยนไปใช้ **Garuda** แทน |
| **XeLaTeX** | ช้ากว่าเล็กน้อย | ได้ **Sarabun** จริง |

เหตุผลคือ Sarabun เป็นไฟล์ฟอนต์รูปแบบใหม่ ส่วน pdfLaTeX เป็นโปรแกรมรุ่นเก่าที่อ่านไฟล์ฟอนต์รูปแบบใหม่ไม่ได้เลย ดังนั้น **ถ้าต้องการ Sarabun จริง ๆ ต้องสร้างไฟล์ด้วย XeLaTeX**

ถ้าคุณสร้างสไลด์ด้วยตัวเลือก `-Thai` หรือ `-t` ระบบตั้งค่านี้ให้แล้ว ไม่ต้องทำอะไรเพิ่ม ถ้าต้องการเปิดเอง ให้เปิดไฟล์ `decks/<ชื่อสไลด์>/.latexmkrc` แล้วลบเครื่องหมาย `#` ออกจากบรรทัดนี้

```perl
$pdf_mode = 5;
```

**EN.** Or force it for one build without changing anything:
**TH.** หรือจะสั่งใช้เฉพาะครั้งเดียวโดยไม่แก้ไฟล์ก็ได้

```powershell
.\scripts\build.ps1 -Deck my-talk -Engine xe      # Windows
```
```bash
./scripts/build.sh -d my-talk -e xe               # macOS / Linux
```

---

## 8. Changing the look / การเปลี่ยนรูปแบบ

### Colours / สี

**EN.** All colours come from **one block of seven lines**. Open `theme/beamercolorthemedeck.sty` and look for the box marked `BRAND PALETTE`. Change the colour codes there and the whole presentation changes to match. You do not need to edit anything else.

**TH.** สีทั้งหมดมาจาก**บล็อกเดียวจำนวนเจ็ดบรรทัด** เปิดไฟล์ `theme/beamercolorthemedeck.sty` แล้วมองหากรอบที่เขียนว่า `BRAND PALETTE` เปลี่ยนรหัสสีตรงนั้น แล้วทั้งงานนำเสนอจะเปลี่ยนตามทันที ไม่ต้องแก้ไฟล์อื่นเลย

```latex
\definecolor{BrandPrimary}{HTML}{14375A}   % headings / หัวเรื่อง
\definecolor{BrandAccent} {HTML}{2E9E8F}   % highlights / จุดเน้น
\definecolor{BrandAlert}  {HTML}{C4453B}   % warnings / คำเตือน
```

### Logo / โลโก้

**EN.** Put your logo file in `theme/assets/`, then in your `metadata.tex` remove the `%` from the last line and point it at your file.

**TH.** วางไฟล์โลโก้ไว้ที่ `theme/assets/` แล้วในไฟล์ `metadata.tex` ให้ลบเครื่องหมาย `%` ออกจากบรรทัดสุดท้าย และแก้ให้ชี้ไปที่ไฟล์ของคุณ

### Turning things off / การปิดส่วนต่าง ๆ

```latex
\usetheme[noprogressbar]{deck}   % hide the bar along the bottom / ซ่อนแถบด้านล่าง
\usetheme[nofooter]{deck}        % hide the footer entirely / ซ่อนแถบท้ายทั้งหมด
```

---

## 9. Pictures, maths, code, references / รูป สมการ โค้ด เอกสารอ้างอิง

**EN.** These are switched on by the lines near the top of your `main.tex`. Delete a line if you do not need it — the build gets faster.

**TH.** ส่วนเหล่านี้เปิดใช้งานจากบรรทัดด้านบนของไฟล์ `main.tex` ถ้าไม่ต้องการส่วนไหนให้ลบบรรทัดนั้นทิ้ง การสร้างไฟล์จะเร็วขึ้น

| Line / บรรทัด | Gives you / ได้อะไร |
|---|---|
| `\input{math}` | Equations and theorems / สมการและทฤษฎีบท |
| `\input{code}` | Colour-highlighted program code / โค้ดโปรแกรมพร้อมไฮไลต์สี |
| `\input{figures}` | Diagrams and charts drawn by the computer / แผนภาพและกราฟที่วาดด้วยคำสั่ง |
| `\input{lang-thai}` | Thai text / ข้อความภาษาไทย |
| `\input{bib}` | Citations and a reference list / การอ้างอิงและรายการเอกสารอ้างอิง |

**EN.** For an ordinary image file, just use:
**TH.** ถ้าเป็นไฟล์รูปภาพธรรมดา ใช้คำสั่งนี้

```latex
\includegraphics[width=0.7\textwidth]{myphoto.png}
```

Put the image in your deck's `figures/` folder.
วางไฟล์รูปไว้ในโฟลเดอร์ `figures/` ของสไลด์นั้น

**EN.** For references: add entries to `refs.bib`, cite them with `\parencite{key}`, and put `\bibliographyframe` where the list should appear.

**TH.** สำหรับเอกสารอ้างอิง ให้เพิ่มรายการในไฟล์ `refs.bib` อ้างอิงด้วย `\parencite{คีย์}` และใส่ `\bibliographyframe` ตรงที่ต้องการให้แสดงรายการ

---

## 10. Where everything lives / ไฟล์ต่าง ๆ อยู่ที่ไหน

```
decks/          your talks — one folder each / สไลด์ของคุณ โฟลเดอร์ละหนึ่งเรื่อง
  _template/    the blank starting point — do not edit / ต้นแบบเปล่า อย่าแก้ไข
  showcase/     the worked example / ตัวอย่างที่ทำเสร็จแล้ว
theme/          colours, fonts, layout / สี ฟอนต์ การจัดวาง
preamble/       optional features / ส่วนเสริมที่เลือกเปิดได้
scripts/        the build commands / คำสั่งสำหรับสร้างไฟล์
build/          finished PDFs land here / ไฟล์ PDF ที่เสร็จแล้วจะมาอยู่ที่นี่
```

**EN.** Inside a deck you will also see a folder called `out/`. That holds the computer's working files. You can ignore it, and you can delete it any time.

**TH.** ในโฟลเดอร์สไลด์แต่ละอันจะมีโฟลเดอร์ชื่อ `out/` ด้วย ซึ่งเก็บไฟล์ระหว่างการทำงานของโปรแกรม ไม่ต้องสนใจ และจะลบทิ้งเมื่อไหร่ก็ได้

---

## 11. When something goes wrong / เมื่อเกิดปัญหา

**EN.** The error messages from this system are famously unhelpful. Almost every problem is one of these five.

**TH.** ข้อความแจ้งข้อผิดพลาดของระบบนี้ขึ้นชื่อเรื่องอ่านยาก แต่ปัญหาเกือบทั้งหมดคือห้าข้อนี้

| What you see / อาการ | The cause / สาเหตุ |
|---|---|
| Build fails on a slide with code<br>สร้างไฟล์ไม่ผ่านที่สไลด์ซึ่งมีโค้ด | Missing `[fragile]`<br>ลืมใส่ `[fragile]` |
| Thai shows as empty boxes □□□<br>ภาษาไทยขึ้นเป็นกล่องว่าง □□□ | Thai in a title without `\thaiinline{}`<br>ภาษาไทยในหัวเรื่องไม่ได้ครอบด้วย `\thaiinline{}` |
| Thai looks wrong, not Sarabun<br>ภาษาไทยหน้าตาไม่เหมือน Sarabun | Built with pdfLaTeX — see section 7<br>สร้างด้วย pdfLaTeX ดูหัวข้อ 7 |
| Slide numbers or citations wrong<br>เลขสไลด์หรือการอ้างอิงผิด | Build once more; they need two passes<br>สั่งสร้างอีกครั้ง ระบบต้องทำงานสองรอบ |
| `Undefined control sequence \xpg@aux`<br>ขึ้นข้อความ `Undefined control sequence \xpg@aux` | Left-over files from a different mode — see the note below<br>มีไฟล์ค้างจากโหมดอื่น ดูหมายเหตุข้างล่าง |
| Nothing makes sense any more<br>อะไร ๆ ก็ผิดไปหมด | Clean and rebuild (below)<br>ล้างไฟล์แล้วสร้างใหม่ (ข้างล่าง) |

> **EN — switching between the two modes.** The two modes leave behind working
> files the other one cannot read. The `build` scripts notice this and clean up
> for you automatically, so if you always build with them you will never see it.
> If you run `latexmk` directly and switch modes, delete the deck's `out/`
> folder first.
>
> **TH — การสลับระหว่างสองโหมด** แต่ละโหมดจะทิ้งไฟล์ระหว่างทำงานที่อีกโหมดหนึ่งอ่านไม่ได้
> สคริปต์ `build` ตรวจพบเรื่องนี้และล้างไฟล์ให้อัตโนมัติ ถ้าคุณสร้างไฟล์ผ่านสคริปต์เสมอ
> ก็จะไม่เจอปัญหานี้ แต่ถ้าคุณสั่ง `latexmk` เองแล้วสลับโหมด ให้ลบโฟลเดอร์ `out/`
> ของสไลด์นั้นก่อน

**EN.** Clean and start fresh:
**TH.** ล้างไฟล์แล้วเริ่มใหม่

```powershell
.\scripts\clean.ps1          # Windows
```
```bash
./scripts/clean.sh           # macOS / Linux
```

**EN.** If it still fails, open `decks/<your-talk>/out/main.log` and search for a line starting with `!`. That is the real error; everything after it is usually noise caused by the first one.

**TH.** ถ้ายังไม่หาย ให้เปิดไฟล์ `decks/<ชื่อสไลด์>/out/main.log` แล้วค้นหาบรรทัดที่ขึ้นต้นด้วย `!` บรรทัดนั้นคือข้อผิดพลาดจริง ส่วนที่ตามมามักเป็นผลพวงจากข้อแรกเท่านั้น

---

## 12. Command summary / สรุปคำสั่ง

| Purpose / จุดประสงค์ | Windows | macOS / Linux |
|---|---|---|
| Build one talk / สร้างสไลด์เรื่องเดียว | `.\scripts\build.ps1 -Deck NAME` | `./scripts/build.sh -d NAME` |
| Build all / สร้างทั้งหมด | `.\scripts\build.ps1` | `./scripts/build.sh` |
| Rebuild on save / สร้างใหม่ทุกครั้งที่บันทึก | `.\scripts\build.ps1 -Deck NAME -Watch` | `./scripts/build.sh -d NAME -w` |
| Force XeLaTeX / บังคับใช้ XeLaTeX | `.\scripts\build.ps1 -Deck NAME -Engine xe` | `./scripts/build.sh -d NAME -e xe` |
| New talk / สร้างเรื่องใหม่ | `.\scripts\new-deck.ps1 -Name NAME` | `./scripts/new-deck.sh -n NAME` |
| New Thai talk / สร้างเรื่องใหม่ภาษาไทย | `.\scripts\new-deck.ps1 -Name NAME -Thai` | `./scripts/new-deck.sh -n NAME -t` |
| Clean up / ล้างไฟล์ | `.\scripts\clean.ps1` | `./scripts/clean.sh` |

**EN.** In VS Code you can also press `Ctrl+Shift+B` (`Cmd+Shift+B` on Mac) to build the talk you are currently editing.

**TH.** ถ้าใช้ VS Code สามารถกด `Ctrl+Shift+B` (บน Mac คือ `Cmd+Shift+B`) เพื่อสร้างสไลด์เรื่องที่กำลังแก้ไขอยู่ได้เลย

---

## Font licence / สัญญาอนุญาตฟอนต์

**EN.** The Sarabun font in `theme/assets/fonts/` is used under the SIL Open Font License, which permits redistribution. The licence text is included beside the font files as `OFL.txt`. Keep that file if you share this folder.

**TH.** ฟอนต์ Sarabun ในโฟลเดอร์ `theme/assets/fonts/` ใช้ภายใต้สัญญาอนุญาต SIL Open Font License ซึ่งอนุญาตให้เผยแพร่ต่อได้ ตัวสัญญาอนุญาตอยู่ในไฟล์ `OFL.txt` ข้าง ๆ ไฟล์ฟอนต์ กรุณาเก็บไฟล์นั้นไว้ด้วยหากคุณส่งต่อโฟลเดอร์นี้
