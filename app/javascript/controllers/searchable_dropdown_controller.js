import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="searchable-dropdown"
export default class extends Controller {
  static targets = ["input", "select", "option", "container"]
  static values = { 
    placeholder: String,
    emptyMessage: String 
  }

  connect() {
    this.createSearchInput()
    this.setupEventListeners()
    this.originalOptions = Array.from(this.selectTarget.options)
    
    // Set default values
    if (!this.placeholderValue) this.placeholderValue = "Search..."
    if (!this.emptyMessageValue) this.emptyMessageValue = "No results found"
  }

  createSearchInput() {
    // Create wrapper div for better styling
    const wrapper = document.createElement('div')
    wrapper.className = 'searchable-dropdown-wrapper'
    
    // Create search input
    const searchInput = document.createElement('input')
    searchInput.type = 'text'
    searchInput.placeholder = this.placeholderValue
    searchInput.className = 'searchable-dropdown-input'
    searchInput.setAttribute('data-searchable-dropdown-target', 'input')
    
    // Create dropdown container
    const dropdownContainer = document.createElement('div')
    dropdownContainer.className = 'searchable-dropdown-container'
    dropdownContainer.setAttribute('data-searchable-dropdown-target', 'container')
    
    // Hide original select
    this.selectTarget.style.display = 'none'
    
    // Insert wrapper before the original select
    this.selectTarget.parentNode.insertBefore(wrapper, this.selectTarget)
    
    // Append elements to wrapper
    wrapper.appendChild(searchInput)
    wrapper.appendChild(dropdownContainer)
    wrapper.appendChild(this.selectTarget)
    
    this.createDropdownOptions()
  }

  createDropdownOptions() {
    const container = this.containerTarget
    container.innerHTML = ''
    
    this.originalOptions.forEach((option, index) => {
      if (option.value === '') return // Skip empty prompt option
      
      const optionDiv = document.createElement('div')
      optionDiv.className = 'searchable-dropdown-option'
      optionDiv.textContent = option.textContent
      optionDiv.setAttribute('data-value', option.value)
      optionDiv.setAttribute('data-searchable-dropdown-target', 'option')
      
      // Mark as selected if this option is selected in original select
      if (option.selected) {
        optionDiv.classList.add('selected')
        this.inputTarget.value = option.textContent
      }
      
      container.appendChild(optionDiv)
    })
    
    // Add empty message div (hidden by default)
    const emptyDiv = document.createElement('div')
    emptyDiv.className = 'searchable-dropdown-empty'
    emptyDiv.textContent = this.emptyMessageValue
    emptyDiv.style.display = 'none'
    container.appendChild(emptyDiv)
  }

  setupEventListeners() {
    // Focus/blur events for dropdown visibility
    document.addEventListener('click', this.handleDocumentClick.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleDocumentClick.bind(this))
  }

  handleDocumentClick(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown()
    }
  }

  inputFocus() {
    this.showDropdown()
  }

  inputInput() {
    this.filterOptions()
    this.showDropdown()
  }

  inputKeydown(event) {
    const visibleOptions = this.getVisibleOptions()
    const currentSelected = this.containerTarget.querySelector('.highlighted')
    
    if (event.key === 'ArrowDown') {
      event.preventDefault()
      this.highlightNext(visibleOptions, currentSelected)
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      this.highlightPrevious(visibleOptions, currentSelected)
    } else if (event.key === 'Enter') {
      event.preventDefault()
      if (currentSelected) {
        this.selectOption(currentSelected)
      }
    } else if (event.key === 'Escape') {
      this.hideDropdown()
      this.inputTarget.blur()
    }
  }

  optionClick(event) {
    this.selectOption(event.currentTarget)
  }

  optionMouseenter(event) {
    // Remove highlight from other options
    this.containerTarget.querySelectorAll('.highlighted').forEach(el => {
      el.classList.remove('highlighted')
    })
    // Highlight current option
    event.currentTarget.classList.add('highlighted')
  }

  selectOption(optionElement) {
    const value = optionElement.getAttribute('data-value')
    const text = optionElement.textContent
    
    // Update input
    this.inputTarget.value = text
    
    // Update original select
    this.selectTarget.value = value
    
    // Trigger change event on original select
    this.selectTarget.dispatchEvent(new Event('change', { bubbles: true }))
    
    // Update visual selection
    this.containerTarget.querySelectorAll('.selected').forEach(el => {
      el.classList.remove('selected')
    })
    optionElement.classList.add('selected')
    
    this.hideDropdown()
  }

  filterOptions() {
    const filter = this.inputTarget.value.toLowerCase()
    const options = this.containerTarget.querySelectorAll('.searchable-dropdown-option')
    const emptyMessage = this.containerTarget.querySelector('.searchable-dropdown-empty')
    let visibleCount = 0
    
    options.forEach(option => {
      const text = option.textContent.toLowerCase()
      if (text.includes(filter)) {
        option.style.display = ''
        visibleCount++
      } else {
        option.style.display = 'none'
      }
      // Remove highlight when filtering
      option.classList.remove('highlighted')
    })
    
    // Show/hide empty message
    if (visibleCount === 0 && filter.length > 0) {
      emptyMessage.style.display = 'block'
    } else {
      emptyMessage.style.display = 'none'
    }
  }

  showDropdown() {
    this.containerTarget.classList.add('show')
  }

  hideDropdown() {
    this.containerTarget.classList.remove('show')
    this.containerTarget.querySelectorAll('.highlighted').forEach(el => {
      el.classList.remove('highlighted')
    })
  }

  getVisibleOptions() {
    return Array.from(this.containerTarget.querySelectorAll('.searchable-dropdown-option')).filter(
      option => option.style.display !== 'none'
    )
  }

  highlightNext(visibleOptions, currentSelected) {
    if (visibleOptions.length === 0) return
    
    if (!currentSelected) {
      visibleOptions[0].classList.add('highlighted')
    } else {
      const currentIndex = visibleOptions.indexOf(currentSelected)
      currentSelected.classList.remove('highlighted')
      const nextIndex = (currentIndex + 1) % visibleOptions.length
      visibleOptions[nextIndex].classList.add('highlighted')
    }
  }

  highlightPrevious(visibleOptions, currentSelected) {
    if (visibleOptions.length === 0) return
    
    if (!currentSelected) {
      visibleOptions[visibleOptions.length - 1].classList.add('highlighted')
    } else {
      const currentIndex = visibleOptions.indexOf(currentSelected)
      currentSelected.classList.remove('highlighted')
      const prevIndex = currentIndex === 0 ? visibleOptions.length - 1 : currentIndex - 1
      visibleOptions[prevIndex].classList.add('highlighted')
    }
  }
}