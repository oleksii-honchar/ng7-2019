import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ShoppingListEditComponent } from './components/shopping-list-edit/shopping-list-edit.component';
import { ShoppingListComponent } from './shopping-list.component';
import { IngredientComponent } from './components/ingredient/ingredient.component';

@NgModule({
  declarations: [
    ShoppingListComponent,
    ShoppingListEditComponent,
    IngredientComponent,
  ],
  exports: [
    ShoppingListComponent,
  ],
  imports: [
    CommonModule,
  ],
})
export class ShoppingListModule { }
