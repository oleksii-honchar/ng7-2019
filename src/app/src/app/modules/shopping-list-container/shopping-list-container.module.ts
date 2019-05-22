import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ShoppingListComponent } from './components/shopping-list/shopping-list.component';
import { ShoppingListEditComponent } from './components/shopping-list-edit/shopping-list-edit.component';
import { IngredientComponent } from './components/ingredient/ingredient.component';
import { ShoppingListContainerComponent } from './shopping-list-container.component';

@NgModule({
  declarations: [
    ShoppingListContainerComponent,
    ShoppingListComponent,
    ShoppingListEditComponent,
    IngredientComponent
  ],
  exports: [
    ShoppingListContainerComponent
  ],
  imports: [
    CommonModule
  ]
})
export class ShoppingListContainerModule { }
