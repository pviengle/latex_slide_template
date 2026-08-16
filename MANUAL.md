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
.\scripts\build.ps1                 # -> build\<folder-name>.pdf
```

**macOS / Linux**
```bash
./scripts/build.sh
```

**EN.** The PDF appears at `build/showcase.pdf`. Open it — you will see every feature this template offers.

**TH.** ไฟล์ PDF จะไปอยู่ที่ `build/showcase.pdf` เปิดดูได้เลย ในไฟล์นั้นจะแสดงความสามารถทั้งหมดของเทมเพลตนี้

> **macOS note / หมายเหตุสำหรับ macOS:** the first time, you may need to allow the scripts to run:
> `chmod +x scripts/*.sh`
> ครั้งแรกอาจต้องอนุญาตให้สคริปต์ทำงานก่อน ด้วยคำสั่งข้างบน

---

## 4. Using TeXstudio / ใช้งานกับ TeXstudio

**EN.** You do not have to use the scripts. If you prefer a normal editor with a build button, this template works in **TeXstudio** with **no settings to change at all**.

1. Open **`main.tex`** in TeXstudio (the one in this folder — it is the presentation).
2. Press the green **Build & View** arrow (or `F5`).

That is the whole procedure. It works because the first lines of every `main.tex` tell TeXstudio what it needs to know, and because `main.tex` finds the shared theme by itself.

**TH.** คุณไม่จำเป็นต้องใช้สคริปต์ ถ้าถนัดโปรแกรมแก้ไขข้อความที่มีปุ่มสร้างไฟล์ เทมเพลตนี้ใช้กับ **TeXstudio** ได้เลย **โดยไม่ต้องตั้งค่าอะไรเลย**

1. เปิดไฟล์ **`main.tex`** ใน TeXstudio (ไฟล์ที่อยู่ในโฟลเดอร์นี้ คือตัวสไลด์)
2. กดปุ่มลูกศรสีเขียว **Build & View** (หรือปุ่ม `F5`)

เท่านี้เอง ที่ทำได้เพราะบรรทัดแรก ๆ ของไฟล์ `main.tex` ทุกไฟล์บอกข้อมูลที่ TeXstudio ต้องรู้ไว้แล้ว และตัว `main.tex` หาไฟล์ธีมที่ใช้ร่วมกันเจอเอง

### The lines that make it work / บรรทัดที่ทำให้ใช้งานได้

**EN.** At the top of every `main.tex` you will see:

**TH.** ที่ด้านบนของไฟล์ `main.tex` ทุกไฟล์ จะเห็นบรรทัดเหล่านี้

```latex
% !TeX program = xelatex
% !BIB program = biber
% !TeX encoding = UTF-8
```

| Line / บรรทัด | What it does / ทำหน้าที่อะไร |
|---|---|
| `!TeX program` | Picks the build engine for this file<br>เลือกโปรแกรมสร้างไฟล์สำหรับไฟล์นี้ |
| `!BIB program` | Uses **biber** for references, not the older bibtex<br>ใช้ **biber** จัดการเอกสารอ้างอิง ไม่ใช่ bibtex รุ่นเก่า |
| `!TeX encoding` | Keeps Thai text readable<br>ทำให้ข้อความภาษาไทยไม่เพี้ยน |

**EN.** It says `xelatex` because Thai is switched on. Thai needs XeLaTeX — it is the only engine that can read Sarabun and the only one that switches to it automatically. **If your talk has no Thai at all**, you may change this to `pdflatex` for a slightly faster build, and set `$pdf_mode = 1` in `.latexmkrc` to match. Change one without the other and the two disagree.

**TH.** ที่เขียนว่า `xelatex` เพราะเปิดใช้ภาษาไทยไว้ ภาษาไทยต้องใช้ XeLaTeX เท่านั้น เพราะเป็นโปรแกรมเดียวที่อ่านฟอนต์ Sarabun ได้ และสลับไปใช้ให้เองอัตโนมัติ **ถ้าสไลด์ไม่มีภาษาไทยเลย** จะเปลี่ยนเป็น `pdflatex` เพื่อให้สร้างไฟล์เร็วขึ้นก็ได้ และต้องตั้ง `$pdf_mode = 1` ใน `.latexmkrc` ให้ตรงกันด้วย ถ้าแก้อย่างเดียวจะขัดกัน

**EN.** Each file in `sections/` also starts with `% !TeX root = ../main.tex`. That tells TeXstudio "this is part of a bigger document" — so you can press build while looking at any section file and it still builds the whole talk instead of complaining.

**TH.** ไฟล์ในโฟลเดอร์ `sections/` แต่ละไฟล์ก็ขึ้นต้นด้วย `% !TeX root = ../main.tex` เป็นการบอก TeXstudio ว่า "ไฟล์นี้เป็นส่วนหนึ่งของเอกสารใหญ่" ทำให้คุณกดปุ่มสร้างไฟล์ขณะเปิดไฟล์ section ไหนอยู่ก็ได้ โปรแกรมจะสร้างสไลด์ทั้งชุดให้ ไม่ขึ้นข้อความผิดพลาด

### Two small things to know / ข้อควรรู้สองอย่าง

**EN.**

- **The PDF sits next to `main.tex`.** TeXstudio puts `main.pdf` in the same folder as the source. The scripts instead put it in `out/` and copy it to `build/`. Both are fine; they just do not know about each other, so if you use both you will have two PDFs. The one from TeXstudio is always the one TeXstudio shows you.
- **Click to jump.** Ctrl-click a line in the PDF to jump to that line of source, and vice versa. This works because the build writes a `.synctex.gz` file.

**TH.**

- **ไฟล์ PDF จะอยู่ข้าง ๆ `main.tex`** TeXstudio วางไฟล์ `main.pdf` ไว้โฟลเดอร์เดียวกับไฟล์ต้นฉบับ ส่วนสคริปต์จะวางไว้ในโฟลเดอร์ `out/` แล้วคัดลอกไป `build/` ทั้งสองแบบใช้ได้ปกติ เพียงแต่ต่างฝ่ายต่างไม่รู้จักกัน ถ้าใช้ทั้งสองแบบก็จะมีไฟล์ PDF สองไฟล์ ไฟล์ที่ TeXstudio แสดงให้ดูคือไฟล์ที่ TeXstudio สร้างเสมอ
- **คลิกเพื่อกระโดดไปมาได้** กด Ctrl แล้วคลิกที่บรรทัดใน PDF จะกระโดดไปยังบรรทัดนั้นในไฟล์ต้นฉบับ และทำย้อนกลับได้ด้วย ใช้ได้เพราะการสร้างไฟล์เขียนไฟล์ `.synctex.gz` ไว้ให้

### Optional: use latexmk inside TeXstudio / ทางเลือก: ใช้ latexmk ใน TeXstudio

**EN.** The built-in build runs the engine **once**. For a talk with a table of contents, slide numbers or references, one pass is not always enough — you may see `??` where a number should be. Pressing build a second time fixes it.

To avoid that entirely, switch TeXstudio to `latexmk`, which repeats the run as many times as needed:

**Options → Configure TeXstudio → Build**, set **Default Compiler** to **`txs:///latexmk`**.

Then add `out` to **Options → Configure TeXstudio → Build → Additional Search Paths → PDF Files**, so the viewer can find the PDF in `out/`.

> One caveat: TeXstudio's stock latexmk command contains `-pdf`, which forces pdfLaTeX and would override a Thai deck's XeLaTeX setting. If you use latexmk **and** Thai, change that command to `latexmk.exe -silent -synctex=1 %` — without `-pdf`, so the deck's own `.latexmkrc` decides.

**TH.** ปุ่มสร้างไฟล์ปกติจะรันโปรแกรมแค่ **รอบเดียว** สำหรับสไลด์ที่มีสารบัญ เลขหน้า หรือเอกสารอ้างอิง รอบเดียวอาจไม่พอ คุณอาจเห็น `??` ตรงที่ควรเป็นตัวเลข กดสร้างซ้ำอีกครั้งก็หาย

ถ้าไม่อยากเจอปัญหานี้เลย ให้เปลี่ยน TeXstudio ไปใช้ `latexmk` ซึ่งจะรันซ้ำให้เองจนครบ

**Options → Configure TeXstudio → Build** แล้วตั้ง **Default Compiler** เป็น **`txs:///latexmk`**

จากนั้นเพิ่มคำว่า `out` ในช่อง **Options → Configure TeXstudio → Build → Additional Search Paths → PDF Files** เพื่อให้โปรแกรมหาไฟล์ PDF ในโฟลเดอร์ `out/` เจอ

> ข้อควรระวัง: คำสั่ง latexmk ที่ TeXstudio ตั้งมาให้มีตัวเลือก `-pdf` อยู่ ซึ่งจะบังคับใช้ pdfLaTeX และไปทับค่า XeLaTeX ของสไลด์ภาษาไทย ถ้าใช้ latexmk **ร่วมกับ** ภาษาไทย ให้แก้คำสั่งเป็น `latexmk.exe -silent -synctex=1 %` คือตัด `-pdf` ออก เพื่อให้ไฟล์ `.latexmkrc` ของสไลด์เป็นคนตัดสินใจ

### Other editors / โปรแกรมอื่น

**EN.** The same three `% !TeX` lines are understood by **TeXworks**, **TeXShop** (Mac) and the **LaTeX Workshop** extension for VS Code, so those work the same way. **Overleaf** works too — see section 6.

**TH.** บรรทัด `% !TeX` ทั้งสามบรรทัดนี้ใช้ได้กับ **TeXworks**, **TeXShop** (บนแมค) และส่วนเสริม **LaTeX Workshop** ของ VS Code เช่นกัน ส่วน **Overleaf** ก็ใช้ได้ ดูหัวข้อ 6

---

## 5. Start your own talk / เริ่มทำสไลด์ของคุณเอง

**EN.** **Copy this whole folder and rename it.** That is the entire procedure — there is no script to run and nothing inside to repoint.

**TH.** **คัดลอกโฟลเดอร์นี้ทั้งหมดแล้วเปลี่ยนชื่อ** เท่านี้จบ ไม่ต้องรันสคริปต์ และไม่ต้องแก้เส้นทางไฟล์ใด ๆ ข้างใน

```
latex_slide_template/   ->   opdc-5stars/          <- copy and rename
```

**EN.** Then:

1. Open `metadata.tex` and put in your title, name and department.
2. Write your slides in `sections/`.
3. Build — press the button in TeXstudio, or run `.\scripts\build.ps1` / `./scripts/build.sh`.

The PDF is named after the folder, so the copy above produces `build/opdc-5stars.pdf`.

**TH.** จากนั้น

1. เปิดไฟล์ `metadata.tex` แล้วใส่ชื่อเรื่อง ชื่อคุณ และหน่วยงาน
2. เขียนสไลด์ในโฟลเดอร์ `sections/`
3. สั่งสร้างไฟล์ กดปุ่มใน TeXstudio หรือรัน `.\scripts\build.ps1` / `./scripts/build.sh`

ไฟล์ PDF จะตั้งชื่อตามโฟลเดอร์ ตัวอย่างข้างบนจึงได้ไฟล์ `build/opdc-5stars.pdf`

**EN.** Thai is already switched on. Type Thai anywhere — you do not need to enable anything or wrap anything. Delete the `\input{lang-thai}` line in `main.tex` if the talk is English-only.

**TH.** ระบบเปิดรองรับภาษาไทยไว้ให้แล้ว พิมพ์ภาษาไทยได้ทุกที่ ไม่ต้องเปิดอะไรเพิ่มและไม่ต้องครอบคำสั่งใด ๆ ถ้าสไลด์เป็นภาษาอังกฤษล้วน ให้ลบบรรทัด `\input{lang-thai}` ใน `main.tex` ออก

---

## 6. What lives where when you copy / คัดลอกแล้วอะไรอยู่ตรงไหน

**EN.** Everything the talk needs is inside the folder, and every path is relative. Nothing points back at the original, so a copy is fully independent — move it, email it, put it on a USB stick, or **upload it to Overleaf** and press Recompile. About 430 KB, fonts included.

**TH.** ทุกอย่างที่สไลด์ต้องใช้อยู่ในโฟลเดอร์นี้ และเส้นทางไฟล์ทั้งหมดเป็นแบบสัมพัทธ์ ไม่มีอะไรชี้กลับไปที่ต้นฉบับ สำเนาจึงเป็นอิสระอย่างสมบูรณ์ จะย้าย ส่งอีเมล ใส่แฟลชไดรฟ์ หรือ **อัปโหลดขึ้น Overleaf** แล้วกด Recompile ก็ได้ ขนาดประมาณ 430 KB รวมฟอนต์แล้ว

```
your-talk/
  main.tex          the presentation / ตัวสไลด์
  metadata.tex      title, author / ชื่อเรื่อง ชื่อผู้บรรยาย
  sections/         your slides / สไลด์ของคุณ
  figures/          your images / รูปภาพ
  refs.bib          references / เอกสารอ้างอิง
  .latexmkrc        engine + build settings / โปรแกรมสร้างไฟล์และการตั้งค่า
  theme/            the look, and the Sarabun font / ธีมและฟอนต์ Sarabun
  preamble/         maths, code, figures, Thai / คณิตศาสตร์ โค้ด รูป ภาษาไทย
  scripts/          build and clean / สคริปต์สร้างและล้างไฟล์
  showcase/         the worked example / ตัวอย่างที่ใช้งานได้จริง
```

**EN.** `showcase/` is a second, complete deck sitting in a subfolder. It is the working reference for how every feature is written, and it also demonstrates that a deck one level down still finds the shared `theme/`. Delete it once you no longer need it — nothing depends on it.

**TH.** `showcase/` คือสไลด์อีกชุดที่สมบูรณ์ในตัว วางอยู่ในโฟลเดอร์ย่อย ใช้เป็นตัวอย่างอ้างอิงว่าแต่ละความสามารถเขียนอย่างไร และยังแสดงให้เห็นว่าสไลด์ที่อยู่ลึกลงไปหนึ่งชั้นก็ยังหาโฟลเดอร์ `theme/` ที่ใช้ร่วมกันเจอ ถ้าไม่ต้องการแล้วลบทิ้งได้เลย ไม่มีอะไรพึ่งพามัน

### Keeping a second talk beside this one / เก็บสไลด์อีกชุดไว้ด้วยกัน

**EN.** Copy `main.tex`, `metadata.tex`, `sections/` and `.latexmkrc` into a new subfolder, the way `showcase/` is arranged. It will find `theme/` one level up on its own. Build it with `-Deck <foldername>` / `-d <foldername>`, or build everything with `-All` / `-a`.

**TH.** คัดลอก `main.tex`, `metadata.tex`, `sections/` และ `.latexmkrc` ไปไว้ในโฟลเดอร์ย่อยใหม่ จัดวางแบบเดียวกับ `showcase/` มันจะหาโฟลเดอร์ `theme/` ที่อยู่เหนือขึ้นไปหนึ่งชั้นเจอเอง สั่งสร้างด้วย `-Deck <ชื่อโฟลเดอร์>` หรือ `-d <ชื่อโฟลเดอร์>` หรือสร้างทั้งหมดด้วย `-All` / `-a`

### How it finds the theme / มันหาธีมเจอได้อย่างไร

**EN.** `main.tex` looks for `theme/beamerthemedeck.sty` beside itself, then one, two and three folders up, and uses the first one it finds. That single mechanism is why a copy works at any depth with no file to edit.

**TH.** ไฟล์ `main.tex` จะมองหา `theme/beamerthemedeck.sty` ที่ข้างตัวมันเอง แล้วไล่ขึ้นไปหนึ่ง สอง และสามชั้น ใช้อันแรกที่เจอ กลไกเดียวนี้เองที่ทำให้สำเนาใช้งานได้ทุกระดับความลึกโดยไม่ต้องแก้ไฟล์

---

## 7. Writing a slide / การเขียนสไลด์

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

## 8. Thai text / ข้อความภาษาไทย

**EN.** Thai works, and the font used is **Sarabun** — the same typeface as TH Sarabun New, the Thai government standard. The font files are stored inside this folder, so nothing needs installing and it works on any computer you copy this to.

There are two ways to write Thai:

**TH.** ระบบรองรับภาษาไทย และใช้ฟอนต์ **Sarabun** ซึ่งเป็นฟอนต์เดียวกับ TH Sarabun New ที่เป็นฟอนต์มาตรฐานราชการไทย ไฟล์ฟอนต์ถูกเก็บไว้ในโฟลเดอร์นี้แล้ว จึงไม่ต้องติดตั้งอะไรเพิ่ม และใช้งานได้บนคอมพิวเตอร์ทุกเครื่องที่คุณคัดลอกโฟลเดอร์นี้ไป

การเขียนภาษาไทยมีสองวิธี

```latex
% Just type it. Anywhere. There is nothing to wrap.
% พิมพ์ได้เลย ทุกที่ ไม่ต้องครอบอะไรทั้งนั้น
The word ตัวอย่าง means "example".

\title{มาตรฐานข้อมูลเปิดระดับ 5 ดาว}
\begin{frame}{Results / ผลลัพธ์}

% Bold and italic carry across the script boundary
% ตัวหนาและตัวเอียงส่งผลข้ามไปยังภาษาไทยด้วย
\textbf{Results / ผลลัพธ์}
```

> **EN.** On XeLaTeX the template watches the text as it is typeset and switches to Sarabun the instant a Thai character appears, then back to Fira Sans afterwards. Titles, headings, body text, bold, italic — all the same, no macro.
>
> Older slides that still use `\thaiinline{...}` or `\begin{thaipar}` keep working; both are now do-nothing wrappers.
>
> **TH.** เมื่อสร้างไฟล์ด้วย XeLaTeX เทมเพลตจะคอยดูข้อความขณะจัดหน้า และสลับไปใช้ฟอนต์ Sarabun ทันทีที่เจอตัวอักษรไทย แล้วสลับกลับเป็น Fira Sans เมื่อจบ ใช้ได้เหมือนกันหมดทั้งหัวเรื่อง เนื้อหา ตัวหนา ตัวเอียง โดยไม่ต้องเรียกคำสั่งใด ๆ
>
> สไลด์เก่าที่ยังใช้ `\thaiinline{...}` หรือ `\begin{thaipar}` ยังใช้งานได้ตามปกติ ตอนนี้ทั้งสองอย่างไม่ทำอะไรแล้ว

> **EN — if Thai comes out blank:** you are not on XeLaTeX. Check that line 1 of `main.tex` reads `% !TeX program = xelatex` and that `.latexmkrc` has `$pdf_mode = 5;`. A missing glyph prints *nothing* and warns about *nothing*, so a blank slide is the only symptom. Add `\tracinglostchars=3` to `main.tex` to turn every dropped character into a logged error.
>
> **TH — ถ้าภาษาไทยหายไปทั้งหมด:** แสดงว่าไม่ได้ใช้ XeLaTeX ให้ตรวจว่าบรรทัดแรกของ `main.tex` เป็น `% !TeX program = xelatex` และในไฟล์ `.latexmkrc` มี `$pdf_mode = 5;` ตัวอักษรที่ไม่มีในฟอนต์จะ*ไม่แสดงอะไรเลย*และ*ไม่เตือนอะไรเลย* อาการเดียวที่เห็นคือสไลด์ว่าง ถ้าต้องการให้ฟ้อง ให้เพิ่ม `\tracinglostchars=3` ใน `main.tex`

---

## 9. The two build modes / โหมดการสร้างไฟล์สองแบบ

**EN.** There are two ways the computer can turn your text into a PDF. This template supports both, and you rarely need to think about it — but there is one case where it matters.

| Mode | Speed | Thai font |
|---|---|---|
| **pdfLaTeX** (default) | Faster | Falls back to **Garuda** |
| **XeLaTeX** | A little slower | Real **Sarabun** |

The reason: Sarabun is a modern font file, and pdfLaTeX is old enough that it cannot read modern font files at all. So **if you want real Sarabun, the talk must be built with XeLaTeX.**

This is already set for you: `.latexmkrc` in this folder says `$pdf_mode = 5;` and line 1 of `main.tex` says `xelatex`. You only need to touch it to go the other way, for an English-only talk:

**TH.** คอมพิวเตอร์แปลงข้อความของคุณเป็น PDF ได้สองวิธี เทมเพลตนี้รองรับทั้งสองแบบ และโดยปกติคุณไม่ต้องสนใจ แต่มีกรณีหนึ่งที่สำคัญ

| โหมด | ความเร็ว | ฟอนต์ไทย |
|---|---|---|
| **pdfLaTeX** (ค่าเริ่มต้น) | เร็วกว่า | เปลี่ยนไปใช้ **Garuda** แทน |
| **XeLaTeX** | ช้ากว่าเล็กน้อย | ได้ **Sarabun** จริง |

เหตุผลคือ Sarabun เป็นไฟล์ฟอนต์รูปแบบใหม่ ส่วน pdfLaTeX เป็นโปรแกรมรุ่นเก่าที่อ่านไฟล์ฟอนต์รูปแบบใหม่ไม่ได้เลย ดังนั้น **ถ้าต้องการ Sarabun จริง ๆ ต้องสร้างไฟล์ด้วย XeLaTeX**

ระบบตั้งค่านี้ให้แล้ว ไฟล์ `.latexmkrc` ในโฟลเดอร์นี้เขียนว่า `$pdf_mode = 5;` และบรรทัดแรกของ `main.tex` เขียนว่า `xelatex` จะต้องแก้ก็ต่อเมื่อจะทำสไลด์ภาษาอังกฤษล้วนเท่านั้น

```perl
$pdf_mode = 5;
```

**EN.** Or force it for one build without changing anything:
**TH.** หรือจะสั่งใช้เฉพาะครั้งเดียวโดยไม่แก้ไฟล์ก็ได้

```powershell
.\scripts\build.ps1 -Engine xe                   # Windows
```
```bash
./scripts/build.sh -e xe                          # macOS / Linux
```

---

## 10. Changing the look / การเปลี่ยนรูปแบบ

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

## 11. Pictures, maths, code, references / รูป สมการ โค้ด เอกสารอ้างอิง

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

## 12. Where everything lives / ไฟล์ต่าง ๆ อยู่ที่ไหน

```
main.tex        THIS presentation / ตัวสไลด์ชุดนี้
sections/       your slides / สไลด์ของคุณ
showcase/       worked example / ตัวอย่างที่ใช้งานได้จริง
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

## 13. When something goes wrong / เมื่อเกิดปัญหา

**EN.** The error messages from this system are famously unhelpful. Almost every problem is one of these five.

**TH.** ข้อความแจ้งข้อผิดพลาดของระบบนี้ขึ้นชื่อเรื่องอ่านยาก แต่ปัญหาเกือบทั้งหมดคือห้าข้อนี้

| What you see / อาการ | The cause / สาเหตุ |
|---|---|
| Build fails on a slide with code<br>สร้างไฟล์ไม่ผ่านที่สไลด์ซึ่งมีโค้ด | Missing `[fragile]`<br>ลืมใส่ `[fragile]` |
| Thai is missing entirely — blank title, blank line<br>ภาษาไทยหายไปทั้งหมด หัวเรื่องว่าง บรรทัดว่าง | Not built with XeLaTeX. Set `% !TeX program = xelatex` and `$pdf_mode = 5;`<br>ไม่ได้สร้างด้วย XeLaTeX ให้ตั้ง `% !TeX program = xelatex` และ `$pdf_mode = 5;` |
| Thai comes out as Latin gibberish `ćéĺďÇÒÁ`<br>ภาษาไทยกลายเป็นอักษรละตินมั่ว `ćéĺďÇÒÁ` | An old `main.aux` from a different engine. Delete `main.*` beside `main.tex`, or **Tools → Clean Auxiliary Files**<br>มีไฟล์ `main.aux` เก่าจากโปรแกรมอื่นค้างอยู่ ให้ลบไฟล์ `main.*` ที่อยู่ข้าง `main.tex` หรือใช้ **Tools → Clean Auxiliary Files** |
| Thai looks wrong, not Sarabun<br>ภาษาไทยหน้าตาไม่เหมือน Sarabun | Built with pdfLaTeX — see section 9<br>สร้างด้วย pdfLaTeX ดูหัวข้อ 9 |
| Slide numbers or citations wrong<br>เลขสไลด์หรือการอ้างอิงผิด | Build once more; they need two passes<br>สั่งสร้างอีกครั้ง ระบบต้องทำงานสองรอบ |
| `Undefined control sequence \xpg@aux`<br>ขึ้นข้อความ `Undefined control sequence \xpg@aux` | Left-over files from a different mode — see the note below<br>มีไฟล์ค้างจากโหมดอื่น ดูหมายเหตุข้างล่าง |
| Same error, but inside TeXstudio<br>ข้อผิดพลาดเดียวกัน แต่เกิดใน TeXstudio | You changed `% !TeX program` — run **Tools → Clean Auxiliary Files** once<br>คุณเปลี่ยนค่า `% !TeX program` ให้สั่ง **Tools → Clean Auxiliary Files** หนึ่งครั้ง |
| `Cannot find theme/beamerthemedeck.sty`<br>ขึ้นว่าหาไฟล์ `theme/beamerthemedeck.sty` ไม่เจอ | The deck was moved somewhere with no `theme/` at or above it. Copy `theme/` and `preamble/` in beside `main.tex` — section 6C<br>สไลด์ถูกย้ายไปที่ที่ไม่มี `theme/` อยู่ในระดับเดียวกันหรือเหนือขึ้นไป ให้คัดลอก `theme/` กับ `preamble/` มาวางข้าง `main.tex` ดูหัวข้อ 6C |
| Nothing makes sense any more<br>อะไร ๆ ก็ผิดไปหมด | Clean and rebuild (below)<br>ล้างไฟล์แล้วสร้างใหม่ (ข้างล่าง) |

> **EN — switching between the two modes.** The two modes leave behind working
> files the other one cannot read. The `build` scripts notice this and clean up
> for you automatically — including the working files an editor leaves beside
> `main.tex` — so if you always build with them you will never see it.
> If you run `latexmk` directly and switch modes, delete the deck's `out/`
> folder first. In TeXstudio, use **Tools → Clean Auxiliary Files**.
>
> **TH — การสลับระหว่างสองโหมด** แต่ละโหมดจะทิ้งไฟล์ระหว่างทำงานที่อีกโหมดหนึ่งอ่านไม่ได้
> สคริปต์ `build` ตรวจพบเรื่องนี้และล้างไฟล์ให้อัตโนมัติ รวมถึงไฟล์ที่โปรแกรมแก้ไขข้อความ
> ทิ้งไว้ข้าง ๆ `main.tex` ด้วย ถ้าคุณสร้างไฟล์ผ่านสคริปต์เสมอก็จะไม่เจอปัญหานี้
> แต่ถ้าคุณสั่ง `latexmk` เองแล้วสลับโหมด ให้ลบโฟลเดอร์ `out/` ของสไลด์นั้นก่อน
> ถ้าใช้ TeXstudio ให้สั่ง **Tools → Clean Auxiliary Files**

**EN.** Clean and start fresh:
**TH.** ล้างไฟล์แล้วเริ่มใหม่

```powershell
.\scripts\clean.ps1          # Windows
```
```bash
./scripts/clean.sh           # macOS / Linux
```

**EN.** If it still fails, open `out/main.log` and search for a line starting with `!`. That is the real error; everything after it is usually noise caused by the first one.

**TH.** ถ้ายังไม่หาย ให้เปิดไฟล์ `out/main.log` แล้วค้นหาบรรทัดที่ขึ้นต้นด้วย `!` บรรทัดนั้นคือข้อผิดพลาดจริง ส่วนที่ตามมามักเป็นผลพวงจากข้อแรกเท่านั้น

---

## 14. Command summary / สรุปคำสั่ง

| Purpose / จุดประสงค์ | Windows | macOS / Linux |
|---|---|---|
| Build one talk / สร้างสไลด์เรื่องเดียว | `.\scripts\build.ps1 -Deck NAME` | `./scripts/build.sh -d NAME` |
| Build all / สร้างทั้งหมด | `.\scripts\build.ps1` | `./scripts/build.sh` |
| Rebuild on save / สร้างใหม่ทุกครั้งที่บันทึก | `.\scripts\build.ps1 -Deck NAME -Watch` | `./scripts/build.sh -d NAME -w` |
| Force XeLaTeX / บังคับใช้ XeLaTeX | `.\scripts\build.ps1 -Deck NAME -Engine xe` | `./scripts/build.sh -d NAME -e xe` |
| New talk / สร้างเรื่องใหม่ | copy this whole folder and rename it / คัดลอกโฟลเดอร์นี้ทั้งหมดแล้วเปลี่ยนชื่อ | ← same / เหมือนกัน |
| Pack a talk to send / รวมสไลด์เพื่อส่งต่อ | copy the folder, drop `theme/` + `preamble/` in beside `main.tex` — no script<br>คัดลอกโฟลเดอร์ แล้ววาง `theme/` กับ `preamble/` ข้าง `main.tex` ไม่ต้องใช้สคริปต์ | ← same / เหมือนกัน |
| Clean up / ล้างไฟล์ | `.\scripts\clean.ps1` | `./scripts/clean.sh` |

**EN.** Or skip all of it: open `main.tex` in **TeXstudio** and press build — see section 4. In VS Code you can press `Ctrl+Shift+B` (`Cmd+Shift+B` on Mac) to build the talk you are currently editing.

**TH.** หรือจะไม่ใช้คำสั่งเลยก็ได้ เปิดไฟล์ `main.tex` ใน **TeXstudio** แล้วกดปุ่มสร้างไฟล์ ดูหัวข้อ 4 ถ้าใช้ VS Code สามารถกด `Ctrl+Shift+B` (บน Mac คือ `Cmd+Shift+B`) เพื่อสร้างสไลด์เรื่องที่กำลังแก้ไขอยู่ได้เลย

---

## Font licence / สัญญาอนุญาตฟอนต์

**EN.** The Sarabun font in `theme/assets/fonts/` is used under the SIL Open Font License, which permits redistribution. The licence text is included beside the font files as `OFL.txt`. Keep that file if you share this folder.

**TH.** ฟอนต์ Sarabun ในโฟลเดอร์ `theme/assets/fonts/` ใช้ภายใต้สัญญาอนุญาต SIL Open Font License ซึ่งอนุญาตให้เผยแพร่ต่อได้ ตัวสัญญาอนุญาตอยู่ในไฟล์ `OFL.txt` ข้าง ๆ ไฟล์ฟอนต์ กรุณาเก็บไฟล์นั้นไว้ด้วยหากคุณส่งต่อโฟลเดอร์นี้
