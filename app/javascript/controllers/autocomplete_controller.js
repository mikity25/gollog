import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  connect() {
    this.timeout = null
    // 画面の他の場所をクリックしたときに候補リストを閉じるイベント
    this.boundCloseOnOutsideClick = this.closeOnOutsideClick.bind(this)
    document.addEventListener("click", this.boundCloseOnOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
  }

  // 入力されたときに動く（タイピングのたびに呼ばれる）
  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    // 1文字以下の場合は候補を非表示にして終了
    if (query.length < 2) {
      this.clearResults()
      return
    }

    // デバウンス処理（キー入力後300ミリ秒待ってからAPIを呼ぶ）
    // 文字を打つたびに毎回APIを叩いてリクエスト過多になるのを防ぐ安全装置
    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, 300)
  }

  async fetchResults(query) {
    try {
      const response = await fetch(`${this.urlValue}?keyword=${encodeURIComponent(query)}`)
      if (!response.ok) return

      const courses = await response.json()
      this.renderResults(courses)
    } catch (error) {
      console.error("Autocomplete error:", error)
      this.clearResults()
    }
  }

  // 候補リストを画面に描画
  renderResults(courses) {
    this.clearResults()

    if (courses.length === 0) return

    courses.forEach((name) => {
      const li = document.createElement("li")
      li.textContent = name
      li.className =
        "px-4 py-2.5 text-sm text-slate-700 hover:bg-emerald-50 hover:text-emerald-700 cursor-pointer transition-colors border-b border-slate-100 last:border-b-0 flex items-center gap-2"
      
      // クリックしたら入力欄にセット
      li.addEventListener("click", () => this.select(name))
      this.resultsTarget.appendChild(li)
    })

    this.resultsTarget.classList.remove("hidden")
  }

  // リストをクリックして選択したときの処理
  select(name) {
    this.inputTarget.value = name
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }

  // 枠外をクリックしたら候補リストを非表示にする
  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.clearResults()
    }
  }
}