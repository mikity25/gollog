import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "previewContainer", "previewList"]

  connect() {
    // 選択されたファイルを溜めておく「買い物カゴ」を用意
    this.dataTransfer = new DataTransfer()
  }

  preview() {
    const newFiles = Array.from(this.inputTarget.files)

    // 新しく選択されたファイルを「カゴ」に追加（上限4枚まで）
    newFiles.forEach((file) => {
      if (!file.type.startsWith("image/")) return

      // 合計4枚を超えないようにチェック
      if (this.dataTransfer.items.length < 4) {
        this.dataTransfer.items.add(file)
      } else {
        alert("写真は最大4枚まで選択可能です。")
      }
    })

    // input の中身を「カゴの中身」で同期更新
    this.inputTarget.files = this.dataTransfer.files

    // 画面のプレビューを描画
    this.renderPreviews()
  }

  // ✕ボタンを押して特定の写真を削除する
  remove(event) {
    const indexToRemove = parseInt(event.currentTarget.dataset.index, 10)
    
    // 新しいカゴを用意して、削除対象以外のファイルを詰め直す
    const updatedDt = new DataTransfer()
    Array.from(this.dataTransfer.files).forEach((file, index) => {
      if (index !== indexToRemove) {
        updatedDt.items.add(file)
      }
    })

    this.dataTransfer = updatedDt
    this.inputTarget.files = this.dataTransfer.files

    // プレビュー再描画
    this.renderPreviews()
  }

  // プレビューの描画処理
  renderPreviews() {
    const files = Array.from(this.dataTransfer.files)
    this.previewListTarget.innerHTML = ""

    if (files.length === 0) {
      this.previewContainerTarget.classList.add("hidden")
      return
    }

    this.previewContainerTarget.classList.remove("hidden")

    files.forEach((file, index) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const wrapper = document.createElement("div")
        wrapper.className = "relative group flex flex-col items-center border border-gray-200 rounded-lg p-1 bg-gray-50 overflow-hidden shadow-sm"

        // サムネイル画像
        const img = document.createElement("img")
        img.src = e.target.result
        img.className = "w-full h-24 object-cover rounded-md"

        // ✕ボタン（右上）
        const removeBtn = document.createElement("button")
        removeBtn.type = "button"
        removeBtn.dataset.index = index
        removeBtn.className = "absolute top-2 right-2 bg-gray-800/70 hover:bg-red-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold transition duration-150"
        removeBtn.innerHTML = "×"
        removeBtn.title = "この写真を削除"
        removeBtn.addEventListener("click", (evt) => this.remove(evt))

        // ファイル名
        const name = document.createElement("p")
        name.className = "text-[10px] text-gray-500 truncate w-full mt-1 text-center px-1"
        name.textContent = file.name

        wrapper.appendChild(img)
        wrapper.appendChild(removeBtn)
        wrapper.appendChild(name)
        this.previewListTarget.appendChild(wrapper)
      }
      reader.readAsDataURL(file)
    })
  }
}