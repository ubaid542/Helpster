import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["queryInput", "locationInput", "queryDropdown", "locationDropdown", "queryResults", "locationResults"]
  static values = { 
    suggestionsUrl: String,
    debounceDelay: { type: Number, default: 300 }
  }

  connect() {
    this.queryTimeout = null
    this.locationTimeout = null
    this.setupEventListeners()
  }

  disconnect() {
    this.clearTimeouts()
    this.removeEventListeners()
  }

  setupEventListeners() {
    // Bind methods to maintain context
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)
    
    // Add document listeners
    document.addEventListener('click', this.handleDocumentClick)
    document.addEventListener('keydown', this.handleKeydown)
  }

  removeEventListeners() {
    document.removeEventListener('click', this.handleDocumentClick)
    document.removeEventListener('keydown', this.handleKeydown)
  }

  clearTimeouts() {
    if (this.queryTimeout) {
      clearTimeout(this.queryTimeout)
      this.queryTimeout = null
    }
    if (this.locationTimeout) {
      clearTimeout(this.locationTimeout)
      this.locationTimeout = null
    }
  }

  // Handle input in query field
  queryInputChanged() {
    this.clearTimeouts()
    
    const query = this.queryInputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideQueryDropdown()
      return
    }

    this.queryTimeout = setTimeout(() => {
      this.fetchSuggestions(query, 'query')
    }, this.debounceDelayValue)
  }

  // Handle input in location field
  locationInputChanged() {
    this.clearTimeouts()
    
    const location = this.locationInputTarget.value.trim()
    
    if (location.length < 2) {
      this.hideLocationDropdown()
      return
    }

    this.locationTimeout = setTimeout(() => {
      this.fetchSuggestions(location, 'location')
    }, this.debounceDelayValue)
  }

  // Fetch suggestions from server
  async fetchSuggestions(inputValue, type) {
    try {
      // Show loading state
      this.showLoadingState(type)
      
      const params = new URLSearchParams()
      
      if (type === 'query') {
        params.append('q', inputValue)
        params.append('location', this.locationInputTarget.value.trim())
      } else {
        params.append('q', this.queryInputTarget.value.trim())
        params.append('location', inputValue)
      }

      const response = await fetch(`${this.suggestionsUrlValue}?${params}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (!response.ok) throw new Error('Network response was not ok')

      const data = await response.json()
      
      if (type === 'query') {
        this.displayQuerySuggestions(data.query_suggestions || [])
      } else {
        this.displayLocationSuggestions(data.location_suggestions || [])
      }
    } catch (error) {
      console.error('Error fetching suggestions:', error)
      if (type === 'query') {
        this.showErrorState('query')
      } else {
        this.showErrorState('location')
      }
    }
  }

  // Show loading state
  showLoadingState(type) {
    const html = `
      <div class="px-4 py-3 text-center">
        <div class="suggestions-loading h-4 rounded mb-2"></div>
        <div class="suggestions-loading h-4 rounded w-3/4 mx-auto mb-2"></div>
        <div class="suggestions-loading h-4 rounded w-1/2 mx-auto"></div>
      </div>
    `
    
    if (type === 'query') {
      this.queryResultsTarget.innerHTML = html
      this.showQueryDropdown()
    } else {
      this.locationResultsTarget.innerHTML = html
      this.showLocationDropdown()
    }
  }

  // Show error state
  showErrorState(type) {
    const html = `
      <div class="px-4 py-3 text-center text-gray-500">
        <span class="text-sm">Unable to load suggestions</span>
      </div>
    `
    
    if (type === 'query') {
      this.queryResultsTarget.innerHTML = html
      this.showQueryDropdown()
      setTimeout(() => this.hideQueryDropdown(), 2000)
    } else {
      this.locationResultsTarget.innerHTML = html
      this.showLocationDropdown()
      setTimeout(() => this.hideLocationDropdown(), 2000)
    }
  }

  // Display query suggestions
  displayQuerySuggestions(suggestions) {
    if (suggestions.length === 0) {
      this.hideQueryDropdown()
      return
    }

    const html = suggestions.map((suggestion, index) => {
      const typeIcon = this.getTypeIcon(suggestion.type)
      return `
        <div class="suggestion-item px-4 py-2 hover:bg-gray-100 cursor-pointer flex items-center gap-2" 
             data-action="click->search#selectQuerySuggestion" 
             data-suggestion="${suggestion.text}"
             data-index="${index}">
          <span class="text-gray-500 text-sm">${typeIcon}</span>
          <span class="flex-1">${this.highlightMatch(suggestion.text, this.queryInputTarget.value)}</span>
          <span class="text-xs text-gray-400 capitalize">${suggestion.type}</span>
        </div>
      `
    }).join('')

    this.queryResultsTarget.innerHTML = html
    this.showQueryDropdown()
  }

  // Display location suggestions
  displayLocationSuggestions(suggestions) {
    if (suggestions.length === 0) {
      this.hideLocationDropdown()
      return
    }

    const html = suggestions.map((suggestion, index) => {
      return `
        <div class="suggestion-item px-4 py-2 hover:bg-gray-100 cursor-pointer flex items-center gap-2" 
             data-action="click->search#selectLocationSuggestion" 
             data-suggestion="${suggestion.text}"
             data-index="${index}">
          <span class="text-gray-500 text-sm">📍</span>
          <span class="flex-1">${this.highlightMatch(suggestion.text, this.locationInputTarget.value)}</span>
        </div>
      `
    }).join('')

    this.locationResultsTarget.innerHTML = html
    this.showLocationDropdown()
  }

  // Get icon for suggestion type
  getTypeIcon(type) {
    switch (type) {
      case 'service': return '🔧'
      case 'category': return '📂'
      case 'subcategory': return '📋'
      default: return '🔍'
    }
  }

  // Highlight matching text
  highlightMatch(text, query) {
    if (!query) return text
    
    const regex = new RegExp(`(${query})`, 'gi')
    return text.replace(regex, '<strong class="text-blue-600">$1</strong>')
  }

  // Select query suggestion
  selectQuerySuggestion(event) {
    const suggestion = event.currentTarget.dataset.suggestion
    this.queryInputTarget.value = suggestion
    this.hideQueryDropdown()
    this.queryInputTarget.focus()
  }

  // Select location suggestion
  selectLocationSuggestion(event) {
    const suggestion = event.currentTarget.dataset.suggestion
    this.locationInputTarget.value = suggestion
    this.hideLocationDropdown()
    this.locationInputTarget.focus()
  }

  // Show/hide dropdowns
  showQueryDropdown() {
    this.queryDropdownTarget.classList.remove('hidden')
    this.queryDropdownTarget.classList.add('search-dropdown')
  }

  hideQueryDropdown() {
    this.queryDropdownTarget.classList.add('hidden')
    this.queryDropdownTarget.classList.remove('search-dropdown')
  }

  showLocationDropdown() {
    this.locationDropdownTarget.classList.remove('hidden')
    this.locationDropdownTarget.classList.add('search-dropdown')
  }

  hideLocationDropdown() {
    this.locationDropdownTarget.classList.add('hidden')
    this.locationDropdownTarget.classList.remove('search-dropdown')
  }

  // Handle clicks outside dropdowns
  handleDocumentClick(event) {
    if (!this.element.contains(event.target)) {
      this.hideQueryDropdown()
      this.hideLocationDropdown()
    }
  }

  // Handle keyboard navigation
  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.hideQueryDropdown()
      this.hideLocationDropdown()
      return
    }

    // Handle arrow key navigation within dropdowns
    const activeDropdown = this.getActiveDropdown()
    if (!activeDropdown) return

    const items = activeDropdown.querySelectorAll('.suggestion-item')
    if (items.length === 0) return

    let currentIndex = Array.from(items).findIndex(item => item.classList.contains('highlighted'))

    if (event.key === 'ArrowDown') {
      event.preventDefault()
      currentIndex = currentIndex < items.length - 1 ? currentIndex + 1 : 0
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      currentIndex = currentIndex > 0 ? currentIndex - 1 : items.length - 1
    } else if (event.key === 'Enter' && currentIndex >= 0) {
      event.preventDefault()
      items[currentIndex].click()
      return
    }

    // Update highlighting
    items.forEach(item => item.classList.remove('highlighted', 'bg-gray-100'))
    if (currentIndex >= 0) {
      items[currentIndex].classList.add('highlighted', 'bg-gray-100')
    }
  }

  // Get currently active dropdown
  getActiveDropdown() {
    if (!this.queryDropdownTarget.classList.contains('hidden')) {
      return this.queryDropdownTarget
    }
    if (!this.locationDropdownTarget.classList.contains('hidden')) {
      return this.locationDropdownTarget
    }
    return null
  }

  // Focus handlers
  queryInputFocused() {
    if (this.queryInputTarget.value.trim().length >= 2) {
      this.queryInputChanged()
    }
  }

  locationInputFocused() {
    if (this.locationInputTarget.value.trim().length >= 2) {
      this.locationInputChanged()
    }
  }
}