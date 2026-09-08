import React from 'react';
import './Select.css';

export const Select = React.forwardRef(({
  label,
  error,
  options = [],
  className = '',
  id,
  ...props
}, ref) => {
  const selectId = id || Math.random().toString(36).substring(7);
  
  return (
    <div className={`input-group ${className}`}>
      {label && <label htmlFor={selectId} className="input-label">{label}</label>}
      <select
        ref={ref}
        id={selectId}
        className={`input-field select-field ${error ? 'input-error' : ''}`}
        {...props}
      >
        <option value="" disabled>Select an option</option>
        {options.map((opt) => (
          <option key={opt.value} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>
      {error && <span className="input-error-msg">{error}</span>}
    </div>
  );
});

Select.displayName = 'Select';
